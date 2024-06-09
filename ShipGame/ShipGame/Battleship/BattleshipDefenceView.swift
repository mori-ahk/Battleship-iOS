//
//  BattleshipDefenceView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-09.
//

import SwiftUI

struct BattleshipDefenceView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var currentlySelectedCoordinates: [Coordinate] = []
    @State private var focusedCoordinate: Coordinate?
    @State private var selectionDirection: GeneralDirection?

    var body: some View {
        VStack(spacing: 16) {
            BattleshipDefendGridView(
                currentlySelectedCoordinates: $currentlySelectedCoordinates,
                focusedCoordinate: $focusedCoordinate,
                selectionDirection: $selectionDirection
            )
            if viewModel.state == .select {
                VStack {
                    boardOptionsView
                    ShipsButtonView(
                        isDisabled: { ship in viewModel.defenceGrid.shipAlreadyUsed(ship) }
                    ) { ship in
                        guard currentlySelectedCoordinates.count == ship.size else { return }
                        viewModel.defenceGrid.placeShips(on: currentlySelectedCoordinates, kind: ship)
                        resetSelection()
                    }
                }
            }
        }
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: currentlySelectedCoordinates)
    }
    
    private func resetSelection() {
        currentlySelectedCoordinates.removeAll(keepingCapacity: true)
        focusedCoordinate = nil
        selectionDirection = nil
    }
    
    private func clearGrid() {
        viewModel.defenceGrid.clear()
        resetSelection()
    }
    
    private var boardOptionsView: some View {
        HStack {
            Button(action: resetSelection) { Text("Reset Selection") }
            Button(action: clearGrid) { Text("Clear Grid") }
        }
        .buttonStyle(.borderedProminent)
    }
}
