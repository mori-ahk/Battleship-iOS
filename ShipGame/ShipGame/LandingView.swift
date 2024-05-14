//
//  LandingView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var landingViewModel = LandingViewModel()
    @State private var shouldShowGrid: Bool = false
    @State private var shouldShowRoomIdAlert: Bool = false
    @State private var gameId: String = String()
    
    var body: some View {
        ZStack {
            if !shouldShowGrid {
                VStack {
                    Button {
                        landingViewModel.createGame()
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
                if let gameId = landingViewModel.gameId {
                    GridView(gameId: gameId)
                }
            }
        }
        .alert("Enter game Id", isPresented: $shouldShowRoomIdAlert) {
            TextField("Enter game Id", text: $gameId)
            Button("join") {
                guard !gameId.isEmpty else { return }
                landingViewModel.joinGame(to: gameId)
            }
        }
        .onReceive(landingViewModel.$gameId) { roomId in
            guard roomId != nil else { return }
            self.shouldShowGrid = true
        }
        .animation(.default, value: shouldShowGrid)
    }
}
