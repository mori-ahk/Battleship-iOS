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
    @State private var isTurn: Bool = false

    var body: some View {
        VStack {
            BattleshipDefendGridView(
                currentlySelectedCoordinates: $currentlySelectedCoordinates,
                focusedCoordinate: $focusedCoordinate,
                selectionDirection: $selectionDirection
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .onReceive(viewModel.$isTurn) { self.isTurn = $0 }
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: isTurn)
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
