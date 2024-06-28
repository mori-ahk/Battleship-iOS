//
//  GameCreatedView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-09.
//

import SwiftUI

struct GameCreatedView: View {
    @Binding var toast: Toast?
    let game: Game
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Share this game ID")
                .font(.title2)
                .fontWeight(.heavy)
            Text("Your Battleship game has been created! Share the game ID below with a friend to invite them to join the battle")
                .font(.title3)
                .fontWeight(.semibold)
            
            GameIdView(toast: $toast, game: game)
            
            Button {
                action()
            } label: {
                Label("Back", systemImage: "arrow.backward")
                    .padding(8)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
