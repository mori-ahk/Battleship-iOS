//
//  PausedView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-24.
//

import SwiftUI

struct PausedView: View {
    let opponentStatus: OpponentStatus
    var body: some View {
        VStack {
            Group {
                switch opponentStatus {
                case .gracePeriod:
                    Text("The other player is AFK. If they do not return within 2 minutes, the game will end")
                default: EmptyView()
                }
            }
            .multilineTextAlignment(.center)
            .padding()
            .fontWeight(.semibold)
            .lineSpacing(5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.prussianBlue.opacity(0.1))
        )
    }
}
