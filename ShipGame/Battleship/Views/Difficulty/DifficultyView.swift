//
//  DifficultyView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct DifficultyView: View {
    var body: some View {
        VStack {
            Text("Choose a difficulty")
                .font(.title)
                .fontWeight(.bold)
            VStack {
                ForEach(Difficulty.allCases) { difficulty in
                    Button {
                        
                    } label: {
                        Text(difficulty.title)
                            .padding(8)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    DifficultyView()
}
