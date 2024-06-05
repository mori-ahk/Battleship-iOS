//
//  LandingView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import SwiftUI
import Combine

struct LandingView: View {
    @StateObject private var gameViewModel = GameViewModel()
    @State private var shouldShowRoomIdAlert: Bool = false
    @State private var gameId: String = String()
    @State private var gameState: GameState = .idle
    
    var body: some View {
        ZStack {
            switch gameViewModel.state {
            case .idle:
                VStack {
                    Button {
                        gameViewModel.createGame()
                    } label: {
                        Text("Create")
                    }
                    Button {
                        shouldShowRoomIdAlert = true
                    } label: {
                        Text("Join")
                    }
                }
            default:
                GameView()
                    .environmentObject(gameViewModel)
            }
        }
        .alert("Enter game Id", isPresented: $shouldShowRoomIdAlert) {
            TextField("Enter game Id", text: $gameId)
            Button("join") {
                guard !gameId.isEmpty else { return }
                gameViewModel.joinGame(to: gameId)
            }
        }
        .onReceive(gameViewModel.$state) { gameState in
            self.gameState = gameState
        }
        .animation(.default, value: gameState)
    }
}
