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
            case .created(let game):
                GameCreatedView(game: game)
                    .flideOut()
            case .select, .ready:
                VStack {
                    BattleshipDefenceView()
                    if state == .select {
                        ReadyView()
                    }
                }
                .flideOut()
            case .started:
                VStack {
                    BattleshipAttackView()
                    Divider()
                    BattleshipDefenceView()
                }
                .transition(.move(edge: .top))
            default: EmptyView()
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: state)
        .onReceive(viewModel.$state) { gameState in
            self.state = gameState
        }
        .padding()
    }
}
