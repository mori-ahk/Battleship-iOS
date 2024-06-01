//
//  ShipsButtonView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import SwiftUI

struct ShipsButtonView: View {
    var isDisabled: (Ship.Kind) -> Bool
    var onTap: (Ship.Kind) -> Void
    
    var body: some View {
        HStack {
            ForEach(Ship.Kind.allCases) { ship in
                Button {
                    onTap(ship)
                } label: {
                    Text(ship.name)
                }
                .buttonStyle(.borderedProminent)
//                .disabled(gameGrid.shipsCount(of: ship) == 1)
                .disabled(isDisabled(ship))
            }
        }
    }
    
//                    guard currentlySelectedCoordinates.count == ship.size else { return }
//                    gameGrid.placeShips(on: currentlySelectedCoordinates)
//                    resetSelection()
}
