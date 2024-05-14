//
//  LandingViewModel.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import Foundation
import Combine

class LandingViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let webSocket = WebSocketManager()
    @Published var gameId: String?
    
    init() {
        webSocket.connect()
        listen()
    }
    
    func listen() {
        webSocket.resultPipeline
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let failure):
                    print(failure)
                }
            }, receiveValue: { message in
                self.gameId = message?.payload?.gameUuid
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
