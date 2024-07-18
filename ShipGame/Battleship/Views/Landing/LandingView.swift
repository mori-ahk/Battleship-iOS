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
    @State private var phase: LandingViewPhase = .idle
    
    var body: some View {
        VStack(spacing: 16) {
            switch phase {
            case .idle:
                VStack {
                    Text("Welcome to Battleship")
                        .font(.title)
                        .fontWeight(.heavy)
                    ForEach(LandingViewButtonType.allCases) { buttonType in
                        LandingViewButton(
                            shouldShowRoomIdAlert: $shouldShowRoomIdAlert,
                            phase: $phase,
                            buttonType: buttonType,
                            connectionState: connectionState
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .transition(.move(edge: .top))
            case .choosingDifficulty:
                DifficultyView(connectionState: connectionState)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .transition(.move(edge: .bottom))
            }
        }
        .alert(
            "Unable to Join",
            isPresented: Binding(
                get: { connectionState == .failed },
                set: { _ in /* no op */ }
            )
        ) {
            Button("OK", role: .cancel) {
                viewModel.disconnect()
                viewModel.resetConnectionState()
            }
        } message: {
            Text("The game ID you entered does not exist. Please check the ID and try again.")
        }
        .alert("Enter game Id", isPresented: $shouldShowRoomIdAlert) {
            TextField("Enter game Id", text: $gameId)
            Button("Cancel", role: .cancel) { /* no op */ }
            Button("Join") {
                guard !gameId.isEmpty else { return }
                viewModel.gameToJoin = Game(id: gameId)
                viewModel.connect(from: .join)
            }
        }
        .onReceive(viewModel.$connectionState) { newConnectionState in
            self.connectionState = newConnectionState
        }
        .animation(.default, value: connectionState)
        .animation(.default, value: phase)
    }
}
