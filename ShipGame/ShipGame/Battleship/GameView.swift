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
    @EnvironmentObject private var gameViewModel: BattleshipViewModel
    @State private var currentlySelectedCoordinates: [Coordinate] = []
    @State private var focusedCoordinate: Coordinate?
    @State private var selectionDirection: GeneralDirection?
    @State private var selectedAttackCoordinate: Coordinate?
    @State private var shouldStartGame: Bool = false
    var body: some View {
        VStack(spacing: 24) {
//            InstructionsView()
            if shouldStartGame {
                VStack {
                    BattleshipAttackGridView(selectedAttackCoordinate: $selectedAttackCoordinate)
                        .transition(.move(edge: .top))
                    Button {
                        guard let selectedAttackCoordinate else { return }
                        gameViewModel.attack(coordinate: selectedAttackCoordinate)
                    } label: {
                        Text("Attack")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedAttackCoordinate == nil)
                }
                Divider()
            }
           
            BattleshipDefendGridView(
                currentlySelectedCoordinates: $currentlySelectedCoordinates,
                focusedCoordinate: $focusedCoordinate,
                selectionDirection: $selectionDirection
            )
            .environmentObject(gameViewModel)
            
            if !shouldStartGame {
                VStack {
                    boardOptionsView
                    ShipsButtonView(
                        isDisabled: { ship in gameViewModel.gameGrid.shipAlreadyUsed(ship) }
                    ) { ship in
                        guard currentlySelectedCoordinates.count == ship.size else { return }
                        gameViewModel.gameGrid.placeShips(on: currentlySelectedCoordinates, kind: ship)
                        resetSelection()
                    }
                    
                    MessageView(gameState: gameViewModel.state) {
                        gameViewModel.ready()
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: currentlySelectedCoordinates)
        .animation(.default, value: shouldStartGame)
        .onReceive(gameViewModel.$state) { gameState in
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
