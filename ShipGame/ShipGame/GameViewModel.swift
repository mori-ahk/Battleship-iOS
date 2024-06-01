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
    @Published var gameId: String?
    @Published var joinPlayerUuid: String?
    
    init() {
        webSocket.connect()
        listen()
    }
    
    func listen() {
        webSocket.resultPipeline
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { messageType in
                switch messageType {
                case .create(let gameUuid, let hostPlayerUuid):
                    self.gameId = gameUuid
                case .join(let joinPlayerUuid):
                    self.joinPlayerUuid = joinPlayerUuid
                default: break
                }
            })
            .store(in: &cancellables)
    }
    
    func createGame() {
        webSocket.create()
    }
    
    func joinGame(to gameId: String) {
        webSocket.join(gameId: gameId)
    }
}
