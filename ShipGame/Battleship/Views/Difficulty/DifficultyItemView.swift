//
//  DifficultyItemView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct DifficultyItemView: View {
    @Binding var isSelected: Bool
    let difficulty: Difficulty
    var body: some View {
        Button {
            isSelected = true
        } label: {
            VStack {
                HStack {
                    Text(difficulty.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(difficulty.sizeText)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.universal)
                    .fill(.columbiaBlue.tertiary)
                    .overlay {
                        if isSelected {
                            strokedBackground
                        }
                    }
            )
        }
        .buttonStyle(BouncyButtonStyle())
    }
    
    private var strokedBackground: some View {
        RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.universal)
            .stroke(.aqua, lineWidth: 2.5)
    }
}
