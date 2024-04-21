//
//  ContentView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-18.
//

import SwiftUI

let MAX_SELECTION_COUNT: Int = 4
let MAX_SHIPS_COUNT: Int = 3
let GRID_SIZE: Int = 5

enum GeneralDirection {
    case vertical
    case horizontal
}

struct ContentView: View {
    @State private var roomId: String = ""
    @State private var gameGrid = GameGrid(size: GRID_SIZE)
    @State private var currentlySelectedCoordinates: [Coordinate] = []
    @State private var focusedCoordinate: Coordinate?
    @State private var selectionDirection: GeneralDirection?
    @State private var shouldShowInstructions: Bool = false
    @StateObject private var webSocketManager = WebSocketManager()
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
            Grid {
                ForEach(0 ..< gameGrid.size, id: \.self) { row in
                    GridRow {
                        ForEach(0 ..< gameGrid.size, id: \.self) { column in
                            let size: CGFloat = isFocusedCoordinate(row, column) ? 55 : 50
                            let coordinate: Coordinate = Coordinate(x: row, y: column)
                            Button {
                                guard currentlySelectedCoordinates.count != MAX_SELECTION_COUNT else { return }
                                guard !isCurrentlySelected(coordinate) else { return }
                                guard !gameGrid.isOccupied(coordinate) else { return }
                                if currentlySelectedCoordinates.isEmpty {
                                    focusedCoordinate = coordinate
                                    if let focusedCoordinate {
                                        currentlySelectedCoordinates.append(focusedCoordinate)
                                    }
                                } else if isValidSelection(x: row, y: column) {
                                    currentlySelectedCoordinates.append(coordinate)
                                    focusedCoordinate = coordinate
                                    if selectionDirection == nil {
                                        selectionDirection = findDirection()
                                    }
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isCurrentlySelected(coordinate) ? .red : .blue)
                                    .frame(width: size, height: size)
                                    .overlay {
                                        if gameGrid.coordinates[row][column].state == .occupied {
                                            Text("S")
                                                .foregroundStyle(.white)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
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
            
            VStack {
                TextField("Room Id", text: $roomId)
                Button {
                    webSocketManager.join(to: roomId)
                } label: {
                    Text("join")
                }
                
                Button {
                    webSocketManager.join(to: roomId)
                } label: {
                    Text("ready")
                }
            }
            
            Text(webSocketManager.texts)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: gameGrid)
        .animation(.default, value: currentlySelectedCoordinates)
        .animation(.default, value: shouldShowInstructions)
        .padding()
    }
    
    private func isFocusedCoordinate(_ row: Int, _ column: Int) -> Bool {
        if let focusedCoordinate {
            return focusedCoordinate.x == row && focusedCoordinate.y == column
        } else {
            return false
        }
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
    
    private func isValidSelection(x row: Int, y column: Int) -> Bool {
        guard let focusedCoordinate else { return false }
        if let selectionDirection {
            switch selectionDirection {
            case .vertical:
                if isValidNeighbour(x: row, y: column, given: selectionDirection) && focusedCoordinate.y - column == .zero { return true }
                return false
            case .horizontal:
                if isValidNeighbour(x: row, y: column, given: selectionDirection) && focusedCoordinate.x - row == .zero { return true }
                return false
            }
        } else {
            if abs(focusedCoordinate.x - row) == 1 && focusedCoordinate.y - column == .zero { return true }
            if abs(focusedCoordinate.y - column) == 1 && focusedCoordinate.x - row == .zero { return true }
            return false
        }
    }
    
    private func findDirection() -> GeneralDirection? {
        if let lastSelectedCoordinate = currentlySelectedCoordinates.last,
           let fistSelectedCoordinate = currentlySelectedCoordinates.first {
            if abs(lastSelectedCoordinate.x - fistSelectedCoordinate.x) == 1 {
               return .vertical
            }
            
            if abs(lastSelectedCoordinate.y - fistSelectedCoordinate.y) == 1 {
                return .horizontal
            }
            
            return nil
        } else {
            return nil
        }
    }
    
    private func isCurrentlySelected(_ coordinate: Coordinate) -> Bool {
        return currentlySelectedCoordinates.contains(coordinate)
    }
    
    private func isValidNeighbour(x row: Int, y column: Int, given direction: GeneralDirection) -> Bool {
        for coordinate in currentlySelectedCoordinates {
            switch direction {
            case .vertical:
                if abs(coordinate.x - row) == 1 { return true }
            case .horizontal:
                if abs(coordinate.y - column) == 1 { return true }
            }
        }
        return false
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

struct Instruction: Identifiable {
    var id: String { description }
    let description: String
    
    static let all: [Instruction] = [
        .init(description: "Placing your ships on the grid board vertically or horizontally, but not diagonally. Ships cannot overlap or extend off the grid"),
        .init(description: "Once all ships are placed, players take turns guessing coordinates on their opponent's grid to try and hit and sink their ships"),
        .init(description: "When all squares occupied by a ship have been hit, that ship is considered sunk."),
        .init(description: "The game continues until one player sinks all of their opponent's ships")
        
    ]
}
