//
//  BattleshipAttackGridView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import SwiftUI

struct BattleshipAttackGridView: View {
    @State private var attackGrid = GameGrid()
    @Binding var selectedAttackCoordinate: Coordinate?
    
    var body: some View {
        Grid {
            ForEach(0 ..< attackGrid.size, id: \.self) { row in
                GridRow {
                    ForEach(0 ..< attackGrid.size, id: \.self) { column in
                        let coordinate: Coordinate = Coordinate(x: row, y: column)
                        let size: CGFloat = selectedAttackCoordinate == coordinate ? 55 : 50
                        Button {
                            if selectedAttackCoordinate == coordinate {
                                selectedAttackCoordinate = nil
                            } else {
                                selectedAttackCoordinate = coordinate
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(selectedAttackCoordinate == coordinate ? .red : .blue)
                                .frame(width: size, height: size)
                                .overlay {
                                    switch attackGrid.coordinates[row][column].state  {
                                    case .hit:
                                        Text("H")
                                    case .miss:
                                        Text("M")
                                    default: EmptyView()
                                    }
                                }
                        }
                    }
                }
            }
        }
        .animation(.default, value: selectedAttackCoordinate)
    }
}
