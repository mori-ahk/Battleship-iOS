//
//  EndGameView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-11.
//

import SwiftUI

struct EndGameView: View {
    @State private var didRequestRematch: Bool = true
    @State private var shouldShowEndGame: Bool = false
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
                } label: {
                    Text("End game")
                        .padding(8)
                }
                .opacity(shouldShowEndGame ? 1 : 0)
                .blur(radius: shouldShowEndGame ? 0 : 16)
            }
            .buttonStyle(.borderedProminent)
            .fontWeight(.semibold)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.shouldShowEndGame = true
            }
        }
        .padding()
        .animation(.default, value: didRequestRematch)
        .animation(.default, value: shouldShowEndGame)
    }
}
