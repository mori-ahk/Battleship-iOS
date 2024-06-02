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
    @Published var message: MessageType?
    
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
                    case .create(let gameId, let hostPlayerId):
                        self.gameInfo = GameInfo(gameId: gameId, playerId: hostPlayerId, isHost: true)
                    case .join(let joinPlayerId):
                        self.gameInfo?.player = Player(id: joinPlayerId, isHost: false)
                    default: break
                    }
                    self.message = message
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
    
    func ready(coordinates: [[Coordinate]]) {
        let readyMessage = ReadyMessage(
            gameUuid: gameInfo.gameUuid!,
            playerUuid: gameInfo.playerUuid!,
            defenceGrid: coordinates.map {
                coordinate in coordinate.map {
                    $0.state.rawValue
                }
            }
        )
        
        webSocket.ready(readyMessage)
    }
    
    func isPlayerReady() -> Bool {
        guard let player = gameInfo?.player else { return false }
        return player.isReady
    }
    
    func readyUp() {
        gameInfo?.player?.readyUp()
    }
    
    func defenceGrid() -> [[Int]] {
        gameGrid.coordinates.map {
            coordinate in coordinate.map {
                $0.state.rawValue
            }
        }
    }
    
    func attack(coordinate: Coordinate) {
        let attackMessage = ReqAttackMessage(
            gameUuid: gameInfo.gameUuid!,
            playerUuid: gameInfo.playerUuid!,
            x: coordinate.x,
            y: coordinate.y
        )
        
        webSocket.attack(attackMessage)
    }
}
