//
//  GameCreatedView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-09.
//

import SwiftUI

struct GameCreatedView: View {
    @State private var toast: Toast?
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
            
            HStack {
                Text(game.id)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    UIPasteboard.general.string = self.game.id
                    toast = Toast(action: .copy, style: .success)
                }) {
                    Image(systemName: "doc.on.doc")
                        .padding(8)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.prussianBlue.opacity(0.1))
                    .stroke(.prussianBlue)
            }
            
            Button {
                action()
            } label: {
                Label("Back", systemImage: "arrow.backward")
                    .padding(8)
            }
            .buttonStyle(.bordered)
        }
        .toastView(toast: $toast)
        .padding()
    }
}
