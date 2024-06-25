//
//  BattleshipViewModel.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import Foundation
import Combine

enum ConnectionSource {
    case host
    case join
}

enum DisconnectionReason {
    case backgrounded
    case gameEnded
}

class BattleshipViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var webSocket: any WebSocketService = WebSocketManager()
    @Published var defenceGrid = GameGrid()
    @Published var attackGrid = GameGrid()
    @Published private(set) var gameInfo: GameInfo? // FIXME: Find a better way to hold this information
    @Published private(set) var state: GameState = .idle
    @Published private(set) var connectionState: ConnectionState = .idle
    @Published private(set) var shouldEnableReady: Bool = false
    @Published private(set) var isTurn: Bool = false
    
    var isPlayerHost: Bool {
        gameInfo?.player?.isHost ?? false
    }
    
    var previousState: GameState?
    var session: Session?
    var connectionSource: ConnectionSource = .host
    var gameToJoin: Game?
    
    init() {
        webSocket.delegate = self
        listen()
        $defenceGrid
            .receive(on: DispatchQueue.main)
            .sink { gameGrid in
                self.shouldEnableReady = gameGrid.didPlaceAllShips()
            }
            .store(in: &cancellables)
        $gameInfo
            .receive(on: DispatchQueue.main)
            .sink { gameInfo in
                self.isTurn = gameInfo?.player?.isTurn ?? false
            }
            .store(in: &cancellables)
    }
   
    
    func listen() {
        webSocket.responsePipeline
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] message in
                    guard let self else { return }
                    switch message {
                    case .session(let message):
                        session = Session(id: message.id)
                    case .create(let message):
                        gameInfo = message
                        state = .created(message.game)
                    case .join(let message):
                        let joinedPlayer = Player(id: message.playerId!, isHost: false)
                        gameInfo?.player = joinedPlayer
                    case .select:
                        state = .select
                    case .ready:
                        gameInfo?.player?.isReady = true
                        state = .ready
                    case .start:
                        state = .started
                    case .attack(let message):
                        handleAttack(message)
                    case .end(let message):
                        guard let gameResult = GameResult(rawValue: message.playerMatchStatus) else { return }
                        state = .ended(gameResult)
                    case .opponentStatus(let opponentStatus):
                        handleOpponentStatusChange(opponentStatus)
                    default: break
                    }
                }
            )
            .store(in: &cancellables)
    }
   
    private func defenceCoordinates() -> [[Int]] {
        defenceGrid.coordinates.map {
            coordinate in coordinate.map {
                $0.state.value
            }
        }
    }
    
    private func updateGrid(_ attackResult: AttackResult) {
        if attackResult.isTurn {
            self.defenceGrid.setCoordinateState(
                at: attackResult.attackedCoordinate,
                to: attackResult.state
            )
        } else {
            self.attackGrid.setCoordinateState(
                at: attackResult.attackedCoordinate,
                to: attackResult.state
            )
        }
    }
   
    private func handleOpponentStatusChange(_ opponentStatus: OpponentStatus) {
        switch opponentStatus {
        case .gracePeriod:
            previousState = state
            state = .paused(.gracePeriod)
        case .reconnected:
            state = previousState ?? .idle
        case .disconnected:
            didDisconnect()
        }
    }
    
    private func handleAttack(_ message: RespAttackMessage) {
        let attackResult = AttackResult(
            isTurn: message.isTurn,
            state: message.positionState,
            attackedCoordinate: message.attackedCoordinate,
            sunkenShip: message.sunkenShip
        )
        isTurn = attackResult.isTurn
        updateGrid(attackResult)
        state = .attacked(attackResult)
    }
    
    func resetGameState() {
        state = .idle
        defenceGrid.clear()
        attackGrid.clear()
        gameInfo = nil
        shouldEnableReady = false
        isTurn = false
        session = nil
    }
}

extension BattleshipViewModel: BattleshipInterface {
    func ping() async -> Bool {
        return await webSocket.ping()
    }
    
    func connect(from source: ConnectionSource, to sessionId: String? = nil) {
        DispatchQueue.main.async {
            self.connectionState = .connecting
        }
        self.connectionSource = source
        webSocket.connect(to: sessionId)
    }
   
    func disconnect(reason: DisconnectionReason) {
        DispatchQueue.main.async {
            self.connectionState = .disconnecting
        }
        webSocket.disconnect()
    }
    
    func create() {
        let message = Message<Code>(code: .create)
        webSocket.send(message)
    }
    
    func join(game: Game) {
        gameInfo = GameInfo(gameId: game.id)
        let payload = JoinMessage(gameId: game.id, playerId: nil)
        let message = Message<JoinMessage>(code: .join, payload: payload)
        webSocket.send(message)
    }
   
    func ready() {
        guard let gameInfo else { return }
        let payload = ReadyMessage(
            gameUuid: gameInfo.game.id,
            playerUuid: gameInfo.player!.id,
            defenceGrid: defenceCoordinates()
        )
        let message = Message<ReadyMessage>(code: .ready, payload: payload)
        webSocket.send(message)
    }
    
    func attack(coordinate: Coordinate) {
        guard let gameInfo else { return }
        let payload = ReqAttackMessage(
            gameUuid: gameInfo.game.id,
            playerUuid: gameInfo.player!.id,
            x: coordinate.x,
            y: coordinate.y
        )
        
        let message = Message<ReqAttackMessage>(code: .attack, payload: payload)
        webSocket.send(message)
    }
}

extension BattleshipViewModel: WebSocketManagerDelegate {
    func didConnect() {
        guard session == nil else { return }
        if connectionSource == .host {
            self.create()
        } else {
            if let gameToJoin {
                self.join(game: gameToJoin)
            }
        }
        
        DispatchQueue.main.async {
            self.connectionState = .connected
        }
    }
   
    func didDisconnect() {
        DispatchQueue.main.async {
            self.resetGameState()
            self.connectionState = .disconnected
        }
    }
}

