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
                .environmentObject(viewModel)
                .transition(.move(edge: .top))
            Button {
                guard let selectedAttackCoordinate else { return }
                viewModel.attack(coordinate: selectedAttackCoordinate)
            } label: {
                Text("Attack")
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedAttackCoordinate == nil)
        }
    }
}
