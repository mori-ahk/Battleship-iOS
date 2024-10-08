//
//  ContentView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-18.
//

import SwiftUI

enum GeneralDirection {
    case vertical
    case horizontal
}

struct BaseView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var state: GameState = .idle
    @State private var shouldShowInstructions: Bool = false
    @State private var toast: Toast?
    @State private var shouldShowAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                switch state {
                case .idle:
                    LandingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.blurReplace)
                case .created(let game):
                    GameCreatedView(toast: $toast, game: game) {
                        shouldShowAlert = true
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.blurReplace)
                case .ended(let gameResult):
                    EndGameView(gameResult: gameResult) {
                        viewModel.disconnect()
                    } onRematch: {
                        viewModel.rematch(is: .requested)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.blurReplace)
                case .paused(let opponentStatus):
                    PausedView(opponentStatus: opponentStatus)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.blurReplace)
                case .rematch(let rematchStatus):
                    RematchView(status: rematchStatus) {
                        viewModel.rematch(is: .accepted)
                    } onReject: {
                        viewModel.rematch(is: .rejected)
                        viewModel.disconnect()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.blurReplace)
                default:
                    GameplayView(state: state)
                        .transition(.blurReplace)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .transition(.blurReplace)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if shouldShowInstructions {
                InstructionsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background()
                    .transition(.blurReplace)
            }
        }
        .animation(.spring(duration: 0.75), value: state)
        .animation(.spring, value: shouldShowInstructions)
        .onReceive(viewModel.$state) { gameState in
            self.state = gameState
        }
        .alert("Wait!", isPresented: $shouldShowAlert) {
            Button("Disconnect", role: .destructive) {
                viewModel.disconnect()
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to go back? This will disconnect you from the server.")
        }
        .overlay(alignment: .topTrailing) {
            Button {
                shouldShowInstructions.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .frame(width: 32, height: 32)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.universal))
            .shadow(radius: UXMetrics.shadowRedius)
        }
        .toastView(toast: $toast)
        .padding()
    }
}
