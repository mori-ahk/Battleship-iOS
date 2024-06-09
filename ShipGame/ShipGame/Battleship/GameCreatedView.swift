//
//  GameCreatedView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-09.
//

import SwiftUI

struct GameCreatedView: View {
    let game: Game
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Share this game ID")
                .font(.title2)
                .fontWeight(.heavy)
            Text("Your Battleship game has been created! Share the game ID below with a friend to invite them to join the battle")
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack {
                Text(game.id)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    UIPasteboard.general.string = self.game.id
                }) {
                    Image(systemName: "doc.on.doc")
                        .padding()
                        .background(.brunswickGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.brunswickGreen.opacity(0.3))
            }
        }
        .padding()
    }
}
