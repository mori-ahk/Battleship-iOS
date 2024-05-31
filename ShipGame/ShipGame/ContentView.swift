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

struct GridView: View {
    @State private var gameGrid = GameGrid()
    @State private var currentlySelectedCoordinates: [Coordinate] = []
    @State private var focusedCoordinate: Coordinate?
    @State private var selectionDirection: GeneralDirection?
    @State private var shouldShowInstructions: Bool = false
    var gameId: String?
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading) {
                Button {
                    shouldShowInstructions.toggle()
                } label: {
                    Text("Show Instructions")
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                if shouldShowInstructions {
                    ForEach(Array(Instruction.all.enumerated()), id: \.offset) { (index, element) in
                        Text("\(index). \(element.description)")
                    }
                }
            }
            
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
           
            HStack {
                ForEach(Ship.Kind.allCases) { ship in
                    Button {
                        guard currentlySelectedCoordinates.count == ship.size else { return }
                        gameGrid.placeShips(on: currentlySelectedCoordinates)
                        resetSelection()
                    } label: {
                        Text(ship.name)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(gameGrid.shipsCount(of: ship) == 1)
                }
            }
           
            if let gameId {
                Text("Game Id: \(gameId)")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: gameGrid)
        .animation(.default, value: currentlySelectedCoordinates)
        .animation(.default, value: shouldShowInstructions)
        .padding()
    }
    
    private func isSelectedCoordinate(_ row: Int, _ column: Int) -> Bool {
        let coordinate = Coordinate(x: row, y: column)
        return currentlySelectedCoordinates.contains(coordinate)
    }
   
    private var directionInstruction: String? {
        guard let focusedCoordinate else { return nil }
        let validDirections = gameGrid.validDirection(for: focusedCoordinate)
        return validDirections
            .map { $0.description }
            .joined(separator: ",")
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
