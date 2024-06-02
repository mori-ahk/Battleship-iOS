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
    @EnvironmentObject private var gameViewModel: GameViewModel
    @State private var currentlySelectedCoordinates: [Coordinate] = []
    @State private var focusedCoordinate: Coordinate?
    @State private var selectionDirection: GeneralDirection?
    @State private var shouldStartGame: Bool = false
    var body: some View {
        VStack(spacing: 24) {
            InstructionsView()
            BattleshipDefendGridView(
                currentlySelectedCoordinates: $currentlySelectedCoordinates,
                focusedCoordinate: $focusedCoordinate,
                selectionDirection: $selectionDirection
            )
            .environmentObject(gameViewModel)
            
            if !shouldStartGame {
                VStack {
                    ShipsButtonView(
                        isDisabled: { ship in gameGrid.shipAlreadyUsed(ship) }
                    ) { ship in
                        guard currentlySelectedCoordinates.count == ship.size else { return }
                        gameViewModel.gameGrid.placeShips(on: currentlySelectedCoordinates)
                        resetSelection()
                    }
                    
                    MessageView(
                            message: gameViewModel.message,
                            isReady: gameViewModel.isPlayerReady()
                            ) {
                        gameViewModel.readyUp()
                            gameViewModel.ready(readyMessage)
                    }
                }
            } else {
                VStack {
                    
                }
            }
            boardOptionsView
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: currentlySelectedCoordinates)
        .padding()
    }
    
    private func resetSelection() {
        currentlySelectedCoordinates.removeAll(keepingCapacity: true)
        focusedCoordinate = nil
        selectionDirection = nil
    }
    
    private func clearGrid() {
        gameViewModel.gameGrid.clear()
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
