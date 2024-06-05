//
//  LandingViewModel.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let webSocket = WebSocketManager()
    @Published var gameGrid = GameGrid()
    @Published var gameInfo: GameInfo?
    @Published var state: GameState = .idle
    
    init() {
        webSocket.connect()
        listen()
    }
    
    func listen() {
        webSocket.resultPipeline
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
                        self.state = .playerJoined(joinedPlayer)
                    default: break
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func createGame() {
        webSocket.create()
    }
    
    func joinGame(to gameId: String) {
        gameInfo = GameInfo(gameId: gameId)
        webSocket.join(gameId: gameId)
    }
    
    func ready() {
        guard let gameInfo else { return }
        let readyMessage = ReadyMessage(
            gameUuid: gameInfo.game.id,
            playerUuid: gameInfo.player!.id,
            defenceGrid: defenceGrid()
        )
        readyUp()
        webSocket.ready(readyMessage)
    }
    
    func isPlayerReady() -> Bool {
        guard let player = gameInfo?.player else { return false }
        return player.isReady
    }
    
    private func readyUp() {
        gameInfo?.player?.readyUp()
    }
    
    private func defenceGrid() -> [[Int]] {
        gameGrid.coordinates.map {
            coordinate in coordinate.map {
                $0.state.rawValue
            }
        }
    }
    
    func attack(coordinate: Coordinate) {
        guard let gameInfo else { return }
        let attackMessage = ReqAttackMessage(
            gameUuid: gameInfo.game.id,
            playerUuid: gameInfo.player!.id,
            x: coordinate.x,
            y: coordinate.y
        )
        
        webSocket.attack(attackMessage)
    }
}
