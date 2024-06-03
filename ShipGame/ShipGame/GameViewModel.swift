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
    var gameInfo: GameInfo?
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
                    case .create(let gameId, let hostPlayerUuid):
                        self.gameInfo = GameInfo(gameId: gameId, playerUuid: hostPlayerUuid)
                    case .join(let joinPlayerUuid):
                        self.gameInfo?.playerUuid = joinPlayerUuid
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
    
    func ready(_ message: ReadyMessage) {
        webSocket.ready(message)
    }
}
