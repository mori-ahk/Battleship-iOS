//
//  LandingView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import SwiftUI
import Combine

struct LandingView: View {
    @StateObject private var viewModel = BattleshipViewModel()
    @State private var shouldShowRoomIdAlert: Bool = false
    @State private var gameId: String = String()
    @State private var gameState: GameState = .idle
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                VStack {
                    Button {
                        viewModel.create()
                    } label: {
                        Text("Create")
                    }
                    Button {
                        shouldShowRoomIdAlert = true
                    } label: {
                        Text("Join")
                    }
                }
                .buttonStyle(.borderedProminent)
            default:
                GameView()
                    .environmentObject(viewModel)
            }
        }
        .alert("Enter game Id", isPresented: $shouldShowRoomIdAlert) {
            TextField("Enter game Id", text: $gameId)
            Button("join") {
                guard !gameId.isEmpty else { return }
                viewModel.join(game: Game(id: gameId))
            }
        }
        .onReceive(viewModel.$state) { gameState in
            self.gameState = gameState
        }
        .animation(.default, value: gameState)
    }
}
