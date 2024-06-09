//
//  BattleshipAttackGridView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import SwiftUI

struct BattleshipAttackGridView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @Binding var selectedAttackCoordinate: Coordinate?
    
    var body: some View {
        Grid {
            ForEach(0 ..< viewModel.attackGrid.size, id: \.self) { row in
                GridRow {
                    ForEach(0 ..< viewModel.attackGrid.size, id: \.self) { column in
                        let coordinate: Coordinate = Coordinate(x: row, y: column)
                        let size: CGFloat = selectedAttackCoordinate == coordinate ? 55 : 50
                        Button {
                            buttonAction(coordinate)
                        }
                        label: { buttonLabel(coordinate, size) }
                    }
                }
            }
        }
        .animation(.default, value: selectedAttackCoordinate)
    }
   
    private func buttonAction(_ coordinate: Coordinate) {
        if selectedAttackCoordinate == coordinate {
            selectedAttackCoordinate = nil
        } else {
            selectedAttackCoordinate = coordinate
        }
    }
    
    private func buttonLabel(
        _ coordinate: Coordinate,
        _ size: CGFloat
    ) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(selectedAttackCoordinate == coordinate ? .red : .blue)
            .frame(width: size, height: size)
            .overlay {
                switch viewModel.attackGrid.state(at: coordinate) {
                case .hit:
                    Text("H")
                case .miss:
                    Text("M")
                default: EmptyView()
                }
            }
    }
}
