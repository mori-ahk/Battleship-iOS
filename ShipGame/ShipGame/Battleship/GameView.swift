//
//  ContentView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-18.
//

import SwiftUI

enum GeneralDirection {
    case vertical
    case horizontal
}

struct GameView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var currentlySelectedCoordinates: [Coordinate] = []
    @State private var focusedCoordinate: Coordinate?
    @State private var selectionDirection: GeneralDirection?
    @State private var shouldStartGame: Bool = false
    var body: some View {
        VStack(spacing: 24) {
//            InstructionsView()
            if shouldStartGame {
                BattleshipAttackView()
                    .environmentObject(viewModel)
                Divider()
            }
           
            BattleshipDefendGridView(
                currentlySelectedCoordinates: $currentlySelectedCoordinates,
                focusedCoordinate: $focusedCoordinate,
                selectionDirection: $selectionDirection
            )
            .environmentObject(viewModel)
            
            if !shouldStartGame {
                VStack {
                    boardOptionsView
                    ShipsButtonView(
                        isDisabled: { ship in viewModel.defenceGrid.shipAlreadyUsed(ship) }
                    ) { ship in
                        guard currentlySelectedCoordinates.count == ship.size else { return }
                        viewModel.defenceGrid.placeShips(on: currentlySelectedCoordinates, kind: ship)
                        resetSelection()
                    }
                    
                    MessageView(gameState: viewModel.state) {
                        viewModel.ready()
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: currentlySelectedCoordinates)
        .animation(.default, value: shouldStartGame)
        .onReceive(viewModel.$state) { gameState in
            switch gameState {
            case .started:
                self.shouldStartGame = true
            default: break
            }
        }
        .padding()
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
