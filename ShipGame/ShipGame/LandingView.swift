//
//  LandingView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import SwiftUI
import Combine

struct LandingView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var shouldShowRoomIdAlert: Bool = false
    @State private var gameId: String = String()
    
    var body: some View {
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
        .alert("Enter game Id", isPresented: $shouldShowRoomIdAlert) {
            TextField("Enter game Id", text: $gameId)
            Button("join") {
                guard !gameId.isEmpty else { return }
                viewModel.join(game: Game(id: gameId))
            }
        }
    }
}
