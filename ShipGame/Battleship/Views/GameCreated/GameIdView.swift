//
//  GameIdView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct GameIdView: View {
    @Binding var toast: Toast?
    
    let game: Game
    var body: some View {
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
        
    }
}
