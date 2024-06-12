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

struct GameView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var state: GameState = .idle
    @State private var shouldShowInstructions: Bool = false
    var body: some View {
        ZStack {
            if !shouldShowInstructions {
                VStack(spacing: 24) {
                    switch state {
                    case .idle:
                        LandingView()
                            .transition(.blurReplace)
                    case .created(let game):
                        GameCreatedView(game: game)
                            .transition(.blurReplace)
                    case .ended(let gameResult):
                        EndGameView(gameResult: gameResult) {
                            viewModel.resetGameState()
                        }
                        .transition(.blurReplace)
                    default:
                        VStack {
                            BattleshipDefenceView()
                                .frame(maxHeight: .infinity, alignment: .center)
                            Divider()
                            switch state {
                            case .select:
                                ReadyView()
                                    .transition(.blurReplace)
                            case .ready:
                                Text("Waiting for opponent")
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .font(.title3)
                                    .transition(.blurReplace)
                            case .started, .attacked:
                                BattleshipAttackView()
                                    .frame(maxHeight: .infinity, alignment: .center)
                                    .transition(.blurReplace)
                            default: EmptyView()
                            }
                        }
                        .transition(.blurReplace)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .transition(.blurReplace)
            }
            
            if shouldShowInstructions {
                InstructionsView()
                    .transition(.blurReplace)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .animation(.spring(duration: 0.75), value: state)
        .animation(.spring, value: shouldShowInstructions)
        .onReceive(viewModel.$state) { gameState in
            self.state = gameState
        }
        .overlay(alignment: .topTrailing) {
            Button {
                shouldShowInstructions.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .frame(width: 32, height: 32)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)
        }
        .padding()
    }
}
