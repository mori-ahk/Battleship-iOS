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
    let buttonWidth: CGFloat = 180
    let buttonHeight: CGFloat = 40

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to Battleship")
                .font(.title)
                .fontWeight(.heavy)
            Group {
                Button {
                    viewModel.connect(source: .host)
                } label: {
                    ZStack {
                        if connectionState.inProgress {
                            ProgressView()
                        } else {
                            Text("Create a game")
                                .padding(8)
                        }
                    }
                    .frame(width: buttonWidth, height: buttonHeight)
                }
                Button {
                    shouldShowRoomIdAlert = true
                } label: {
                    ZStack {
                        if connectionState.inProgress {
                            ProgressView()
                        } else {
                            Text("Join a game")
                                .padding(8)
                        }
                    }
                    .frame(width: buttonWidth, height: buttonHeight)
                }
            }
            .disabled(connectionState.inProgress)
            .buttonStyle(.borderedProminent)
            .fontWeight(.semibold)
        }
        .alert("Enter game Id", isPresented: $shouldShowRoomIdAlert) {
            TextField("Enter game Id", text: $gameId)
            Button("join") {
                guard !gameId.isEmpty else { return }
                viewModel.connect(source: .join)
                viewModel.gameToJoin = Game(id: gameId)
            }
        }
        .onReceive(viewModel.$connectionState) { newConnectionState in
            self.connectionState = newConnectionState
        }
        .animation(.default, value: connectionState)
    }
}
