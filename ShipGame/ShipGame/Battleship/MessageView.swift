//
//  MessageView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-01.
//

import SwiftUI

struct MessageView: View {
    var gameState: GameState
    var onReady: (() -> Void)? = nil
    var body: some View {
        VStack {
            switch gameState {
            case .created(let game):
                Text("Game Id: \(game.id)")
            case .playerJoined(_):
                EmptyView()
            case .select:
                VStack {
                    Text("Place your ships, and press ready when you're done")
                    Button {
                        onReady?()
                    } label: {
                        Text("Ready")
                    }
                    .buttonStyle(.borderedProminent)
                }
            default: EmptyView()
            }
        }
        .font(.title2)
        .fontWeight(.semibold)
    }
}
