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
    @State private var gameGrid = GameGrid()
    @State private var currentlySelectedCoordinates: [Coordinate] = []
    @State private var focusedCoordinate: Coordinate?
    @State private var selectionDirection: GeneralDirection?

    var body: some View {
        VStack(spacing: 24) {
            InstructionsView()
            BattleshipGridView(
                currentlySelectedCoordinates: $currentlySelectedCoordinates,
                focusedCoordinate: $focusedCoordinate,
                selectionDirection: $selectionDirection,
                gameGrid: gameGrid
            )
            
            HStack {
                Button {
                    resetSelection()
                } label: {
                    Text("Reset Selection")
                }
                .buttonStyle(.borderedProminent)
                Button {
                    clearGrid()
                } label: {
                    Text("Clear Grid")
                }
                .buttonStyle(.borderedProminent)
            }
           
            ShipsButtonView(
                isDisabled: { ship in gameGrid.shipAlreadyUsed(ship) }
            ) { ship in
                guard currentlySelectedCoordinates.count == ship.size else { return }
                gameGrid.placeShips(on: currentlySelectedCoordinates)
                resetSelection()
            }
                
            MessageView(message: gameViewModel.message) {
                if let gameInfo = gameViewModel.gameInfo {
                    let readyMessage = ReadyMessage(
                        gameUuid: gameInfo.game.id,
                        playerUuid: gameInfo.player!.id,
                        defenceGrid: gameGrid.coordinates.map {
                            coordinate in coordinate.map {
                                $0.state.rawValue
                            }
                        }
                    )
                    gameViewModel.ready(readyMessage)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: gameGrid)
        .animation(.default, value: currentlySelectedCoordinates)
        .padding()
    }
    
    private func resetSelection() {
        currentlySelectedCoordinates.removeAll(keepingCapacity: true)
        focusedCoordinate = nil
        selectionDirection = nil
    }
    
    private func clearGrid() {
        gameGrid.clear()
        resetSelection()
    }
}
