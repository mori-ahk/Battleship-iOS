//
//  BattleshipViewModel.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import Foundation
import Combine

class BattleshipViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let webSocket: any WebSocketService = WebSocketManager()
    private var attackedCoordinate: Coordinate? //TODO: server should send this.
    @Published var defenceGrid = GameGrid()
    @Published var attackGrid = GameGrid()
    @Published var gameInfo: GameInfo?
    @Published var state: GameState = .idle
    
    init() {
        webSocket.connect()
        listen()
    }
    
    func listen() {
        webSocket.responsePipeline
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { message in
                    switch message {
                    case .create(let message):
                        self.gameInfo = message
                        self.state = .created(message.game)
                    case .join(let message):
                        let joinedPlayer = Player(id: message.playerId!, isHost: false)
                        self.gameInfo?.player = joinedPlayer
                    case .select:
                        self.state = .select
                    case .ready:
                        self.gameInfo?.player?.isReady = true
                        self.state = .ready
                    case .start:
                        self.state = .started
                    case .attack(let message):
                        let attackResult = AttackResult(
                            isTurn: message.isTurn,
                            state: message.positionState
                        )
                        
                        if let attackedCoordinate = self.attackedCoordinate {
                            self.attackGrid.setCoordinateState(at: attackedCoordinate, to: attackResult.state)
                        }
                        
                        self.state = .attacked(attackResult)
                    default: break
                    }
                }
            )
            .store(in: &cancellables)
    }
   
    func isPlayerReady() -> Bool {
        guard let player = gameInfo?.player else { return false }
        return player.isReady
    }
    
    private func readyUp() {
        gameInfo?.player?.readyUp()
    }
    
    private func defenceCoordinates() -> [[Int]] {
        defenceGrid.coordinates.map {
            coordinate in coordinate.map {
                $0.state.value
            }
        }
    }
}

extension BattleshipViewModel: BattleshipInterface {
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
        attackedCoordinate = coordinate
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
