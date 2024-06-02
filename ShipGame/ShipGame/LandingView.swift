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
    @State private var shouldShowGrid: Bool = false
    @State private var shouldShowRoomIdAlert: Bool = false
    @State private var gameId: String = String()
    
    var body: some View {
        ZStack {
            if !shouldShowGrid {
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
            } else {
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
        .onReceive(gameViewModel.$message) { message in
            guard let message = message else { return }
            self.shouldShowGrid = true
        }
        .animation(.default, value: shouldShowGrid)
    }
}
