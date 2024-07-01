//
//  DifficultyItemView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct DifficultyItemView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @Binding var isSelected: Bool
    let difficulty: Difficulty
    var body: some View {
        Button {
            isSelected = true
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(difficulty.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(difficulty.sizeText)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                if shouldDisableHard {
                    Text("Only available in larger screens")
                        .font(.footnote)
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
        .disabled(shouldDisableHard)
        .buttonStyle(BouncyButtonStyle())
    }
    
    private var strokedBackground: some View {
        RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.universal)
            .stroke(.aqua, lineWidth: 2.5)
    }
    
    private var shouldDisableHard: Bool {
        sizeClass == .compact && difficulty == .hard
    }
}
