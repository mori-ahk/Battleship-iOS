//
//  GameplayView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-24.
//

import SwiftUI

struct GameplayView: View {
    let state: GameState
    var body: some View {
        VStack(spacing: 12) {
            BattleshipDefenceView()
            Divider()
            switch state {
            case .select:
                ReadyView()
                    .transition(.blurReplace)
            case .ready:
                Text("Waiting for opponent")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .font(.title3)
                    .transition(.blurReplace)
            case .started, .attacked:
                BattleshipAttackView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .layoutPriority(1)
                    .transition(.blurReplace)
            default: EmptyView()
            }
        }
    }
}
