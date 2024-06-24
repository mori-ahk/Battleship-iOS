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
                    Text("Player is AFK, if they're not back in 2 mins. This game will end")
                default: EmptyView()
                }
            }
            .multilineTextAlignment(.center)
            .padding()
            .fontWeight(.semibold)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.prussianBlue.opacity(0.1))
        )
    }
}
