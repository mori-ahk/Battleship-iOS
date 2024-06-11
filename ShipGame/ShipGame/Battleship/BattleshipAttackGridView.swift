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
            .fill(coordinateBackgroundColor(at: coordinate))
            .stroke(coordinateBorderColor(at: coordinate), lineWidth: 2)
            .frame(width: size, height: size)
            .overlay {
                Group {
                    switch attackGrid.state(at: coordinate) {
                    case .hit:
                        Text("H")
                    case .miss:
                        Text("M")
                    default: EmptyView()
                    }
                }
            }
    }
   
    private func coordinateBackgroundColor(at coordinate: Coordinate) -> Color {
        if selectedAttackCoordinate == coordinate {
            return .brunswickGreen
        } else {
            switch attackGrid.state(at: coordinate) {
            case .occupied(let ship):
                return ship.color
            case .hit:
                return .red.opacity(0.8)
            case .miss:
                return .gray
            default: return .brunswickGreen.opacity(0.5)
            }
        }
    }
    
    private func coordinateBorderColor(at coordinate: Coordinate) -> Color {
        selectedAttackCoordinate == coordinate ? .mint : .mint.opacity(0.5)
    }
    
    private func size(at coordinate: Coordinate) -> CGFloat {
        switch attackGrid.state(at: coordinate) {
        case .hit, .miss: 50
        case .empty: 40
        case .occupied: 45
        }
    }
}
