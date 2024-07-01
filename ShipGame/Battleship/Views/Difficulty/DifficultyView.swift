//
//  DifficultyView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct DifficultyView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var selectedDifficulty: Difficulty = .easy
    let connectionState: ConnectionState
    
    var body: some View {
        VStack {
            Text("Choose a difficulty")
                .font(.title)
                .fontWeight(.bold)
            VStack {
                ForEach(Difficulty.allCases) { difficulty in
                    DifficultyItemView(
                        isSelected: Binding(
                            get: { selectedDifficulty == difficulty },
                            set: { isSelected in
                                selectedDifficulty = isSelected ? difficulty : .easy
                            }
                        ),
                        difficulty: difficulty
                    )
                }
                Button {
                    viewModel.connect(from: .host)
                } label: {
                    ZStack {
                        if connectionState.inProgress {
                            ProgressView()
                        } else {
                            Text("Continue")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(8)
                        }
                    }
                }
                .disabled(connectionState.inProgress)
                .buttonStyle(.borderedProminent)
                .fontWeight(.semibold)
            }
        }
        .onChange(of: selectedDifficulty) { oldValue, newValue in
            viewModel.gameDifficulty = newValue
        }
        .padding()
        .animation(.default, value: selectedDifficulty)
    }
}
