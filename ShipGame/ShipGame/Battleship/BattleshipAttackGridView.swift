//
//  BattleshipAttackGridView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import SwiftUI

struct BattleshipAttackGridView: View {
    @State private var currentlySelectedCoordniate: Coordinate?
    @State private var attackGrid = GameGrid()
    var body: some View {
        Grid {
            ForEach(0 ..< attackGrid.size, id: \.self) { row in
                GridRow {
                    ForEach(0 ..< attackGrid.size, id: \.self) { column in
                        let coordinate: Coordinate = Coordinate(x: row, y: column)
                        let size: CGFloat = currentlySelectedCoordniate == coordinate ? 55 : 50
                        Button {
                            currentlySelectedCoordniate = coordinate
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(currentlySelectedCoordniate == coordinate ? .red : .blue)
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
    }
}
