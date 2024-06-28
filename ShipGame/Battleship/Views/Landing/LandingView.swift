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
    @State private var connectionState: ConnectionState = .idle

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to Battleship")
                .font(.title)
                .fontWeight(.heavy)
            ForEach(LandingViewButtonType.allCases) { buttonType in
                LandingViewButton(
                    shouldShowRoomIdAlert: $shouldShowRoomIdAlert,
                    buttonType: buttonType,
                    connectionState: connectionState
                )
            }
        }
        .alert("Enter game Id", isPresented: $shouldShowRoomIdAlert) {
            TextField("Enter game Id", text: $gameId)
            Button("join") {
                guard !gameId.isEmpty else { return }
                viewModel.gameToJoin = Game(id: gameId)
                viewModel.connect(from: .join)
            }
        }
        .onReceive(viewModel.$connectionState) { newConnectionState in
            self.connectionState = newConnectionState
        }
        .animation(.default, value: connectionState)
    }
}
