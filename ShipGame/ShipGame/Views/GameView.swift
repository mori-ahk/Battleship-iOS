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
    var body: some View {
        VStack(spacing: 24) {
//            InstructionsView()
            switch state {
            case .idle:
                LandingView()
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
        .frame(maxHeight: .infinity, alignment: .center)
        .animation(.spring(duration: 0.75), value: state)
        .onReceive(viewModel.$state) { gameState in
            self.state = gameState
        }
        .padding()
    }
}
