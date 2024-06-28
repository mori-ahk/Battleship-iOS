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
            if isTurn {
                attackResultTextView
            }
            
            sunkenShipsCountContainerView
            BattleshipDefendGridView(
                currentlySelectedCoordinates: $currentlySelectedCoordinates,
                focusedCoordinate: $focusedCoordinate,
                selectionDirection: $selectionDirection
            )
            .frame(maxHeight: .infinity, alignment: .center)
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
    
    @ViewBuilder
    private var attackResultTextView: some View {
        switch viewModel.state {
        case .attacked(let attackResult):
            if let state = attackResult.state {
                Text("Opponent attack result: ")
                    .font(.headline)
                    .fontWeight(.regular)
                +
                Text(state.description)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundStyle(.red)
            } else { EmptyView() }
        default: EmptyView()
        }
    }
   
    @ViewBuilder
    private var sunkenShipsCountContainerView: some View {
        switch viewModel.state {
        case .attacked(let attackResult):
            let sunkenShip = getSunkenShipsCount(for: attackResult)
            VStack {
                sunkenShipsCountTextView(prefix: "My sunken ships: ", shipsCount: sunkenShip.0)
                sunkenShipsCountTextView(prefix: "Opponent sunken ships: ", shipsCount: sunkenShip.1)
            }
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    private func sunkenShipsCountTextView(prefix: String, shipsCount: Int) -> some View {
        Text(prefix)
            .font(.headline)
            .fontWeight(.regular)
        +
        Text(shipsCount.description)
            .font(.headline)
            .fontWeight(.heavy)
    }
    
    private func getSunkenShipsCount(for attackResult: AttackResult) -> (Int, Int) {
        var mySunkenShips: Int = .zero
        var opponentSunkenShips: Int = .zero
        if viewModel.isPlayerHost {
            mySunkenShips = attackResult.sunkenShip.host
            opponentSunkenShips = attackResult.sunkenShip.join
        } else {
            mySunkenShips = attackResult.sunkenShip.join
            opponentSunkenShips = attackResult.sunkenShip.host
        }
        
        return (mySunkenShips, opponentSunkenShips)
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
