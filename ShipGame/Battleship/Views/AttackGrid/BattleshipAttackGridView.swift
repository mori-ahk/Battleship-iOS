//
//  BattleshipAttackGridView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import SwiftUI

struct BattleshipAttackGridView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var attackGrid = GameGrid()
    @Binding var selectedAttackCoordinate: Coordinate?
    
    var body: some View {
        Grid {
            ForEach(0 ..< attackGrid.size, id: \.self) { row in
                GridRow {
                    ForEach(0 ..< attackGrid.size, id: \.self) { column in
                        let coordinate: Coordinate = Coordinate(x: row, y: column)
                        Button {
                            buttonAction(coordinate)
                        }
                        label: { 
                            buttonLabel(coordinate, size(at: coordinate))
                        }
                        .disabled(!viewModel.isTurn)
                    }
                }
            }
        }
        .onReceive(viewModel.$attackGrid) { newAttackGrid in
            self.attackGrid = newAttackGrid
        }
        .animation(.default, value: selectedAttackCoordinate)
        .animation(.default, value: attackGrid)
    }
   
    private func buttonAction(_ coordinate: Coordinate) {
        guard attackGrid.state(at: coordinate) == .empty else { return }
        if selectedAttackCoordinate == coordinate {
            selectedAttackCoordinate = nil
        } else {
            selectedAttackCoordinate = coordinate
        }
    }
    
    @ViewBuilder
    private func buttonLabel(
        _ coordinate: Coordinate,
        _ size: CGFloat
    ) -> some View {
        let state = attackGrid.state(at: coordinate)
        RoundedRectangle(cornerRadius: UXMetrics.CornerRadius.universal)
            .fill(coordinateBackgroundColor(at: coordinate))
            .frame(width: size, height: size)
            .overlay {
                if let sign = state.sign {
                    Text(sign)
                }
            }
    }
   
    private func coordinateBackgroundColor(at coordinate: Coordinate) -> Color {
        if selectedAttackCoordinate == coordinate {
            return .bittersweet
        } else {
            switch attackGrid.state(at: coordinate) {
            case .occupied(let ship):
                return ship.color
            case .hit:
                return .engineRed
            case .miss:
                return .gray
            case .sunk:
                return .columbiaBlue.opacity(0.2)
            default: return .bittersweet.opacity(0.5)
            }
        }
    }
    
    private func size(at coordinate: Coordinate) -> CGFloat {
        attackGrid.state(at: coordinate).size 
    }
}
