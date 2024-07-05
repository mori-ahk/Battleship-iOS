//
//  EndGameView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-11.
//

import SwiftUI

struct EndGameView: View {
    @State private var didRequestRematch: Bool = true
    var gameResult: GameResult
    var onBack: () -> Void
    var onRematch: () -> Void
    var body: some View {
        VStack {
            Group {
                if !didRequestRematch {
                    Text("Ready to run it back? We're waiting to see if your opponent is up for the challenge!")
                } else {
                    switch gameResult {
                    case .won:
                        Text("You won!")
                    case .lost:
                        Text("You lost!")
                    }
                }
            }
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)

            VStack {
                Button {
                    onRematch()
                    didRequestRematch = false
                } label: {
                    Text("Rematch")
                        .padding(8)
                }
                .disabled(!didRequestRematch)
                
                Button {
                    onBack()
                    didRequestRematch = true
                } label: {
                    Text("Go back")
                        .padding(8)
                }
            }
            .buttonStyle(.borderedProminent)
            .fontWeight(.semibold)
        }
        .padding()
        .animation(.default, value: didRequestRematch)
    }
}
