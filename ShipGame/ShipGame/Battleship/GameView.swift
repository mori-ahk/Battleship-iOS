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
    @State private var shouldStartGame: Bool = false
    var body: some View {
        VStack(spacing: 24) {
//            InstructionsView()
            if shouldStartGame {
                BattleshipAttackView()
                    .environmentObject(viewModel)
                Divider()
            }
            
            if !shouldStartGame {
                VStack {
                    MessageView(gameState: viewModel.state) {
                        viewModel.ready()
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: shouldStartGame)
        .onReceive(viewModel.$state) { gameState in
            switch gameState {
            case .started:
                self.shouldStartGame = true
            default: break
            }
        }
        .padding()
    }
}
