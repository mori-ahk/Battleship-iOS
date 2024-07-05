//
//  EndGameView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-11.
//

import SwiftUI

struct EndGameView: View {
    var gameResult: GameResult
    var onBack: () -> Void
    var onRematch: () -> Void
    var body: some View {
        VStack {
            Group {
                switch gameResult {
                case .won:
                    Text("You won!")
                case .lost:
                    Text("You lost!")
                }
            }
            .font(.title3)
            .fontWeight(.bold)
           
            Group {
                Button {
                    onRematch()
                } label: {
                    Text("Rematch")
                        .padding(8)
                }
                
                Button {
                    onBack()
                } label: {
                    Text("Go back")
                        .padding(8)
                }
            }
            .buttonStyle(.borderedProminent)
            .fontWeight(.semibold)
        }
    }
}
