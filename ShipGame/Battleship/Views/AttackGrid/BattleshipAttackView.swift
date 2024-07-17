//
//  BattleshipAttackView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-09.
//

import SwiftUI

struct BattleshipAttackView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var selectedAttackCoordinate: Coordinate?
    @State private var isTurn: Bool = false
    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.universal)
                .fill(turnBackground)
                .stroke(isTurn ? .green : .columbiaBlue.opacity(0.5), lineWidth: isTurn ? 2 : 1)
                .shadow(color: isTurn ? .green : .green.opacity(0), radius: 4)
                .frame(width: 256)
                .overlay {
                    Text(turnStatusMessage)
                        .padding(2)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(isTurn ? .primary : .secondary)
                        .transition(.blurReplace)
                        .id(turnStatusMessage)
                }

                BattleshipAttackGridView(selectedAttackCoordinate: $selectedAttackCoordinate)
                Button {
                    guard let selectedAttackCoordinate else { return }
                    viewModel.attack(coordinate: selectedAttackCoordinate)
                    self.selectedAttackCoordinate = nil
                } label: {
                    Text("Attack")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .frame(width: 256)
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isTurn || selectedAttackCoordinate == nil)
        }
        .onReceive(viewModel.$isTurn) { isTurn in
            self.isTurn = isTurn
        }
        .animation(.bouncy(extraBounce: 0.35), value: turnStatusMessage)
        .animation(.default, value: isTurn)
    }
    
    private var turnStatusMessage: String {
        if isTurn {
            return "Your turn"
        } else {
            return "Opponent's turn"
        }
    }
    
    private var turnBackground: Color {
        if isTurn {
            return .green.opacity(0.1)
        } else {
            return .columbiaBlue.opacity(0.1)
        }
    }
}
