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
    
    var body: some View {
        VStack {
            BattleshipAttackGridView(selectedAttackCoordinate: $selectedAttackCoordinate)
            Button {
                guard let selectedAttackCoordinate else { return }
                viewModel.attack(coordinate: selectedAttackCoordinate)
                self.selectedAttackCoordinate = nil
            } label: {
                Text("Attack")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.isTurn || selectedAttackCoordinate == nil)
            Text(turnText)
        }
    }
    
    private var turnText: String {
        if viewModel.isTurn {
            return "It is your turn"
        } else {
            return "Waiting for opponent attack"
        }
    }
}
