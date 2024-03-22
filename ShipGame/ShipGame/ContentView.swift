//
//  ContentView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-18.
//

import SwiftUI

let MAX_SELECTION_COUNT: Int = 3
let MAX_SHIPS_COUNT: Int = 3
let GRID_SIZE: Int = 5
enum GeneralDirection {
    case vertical
    case horizontal
}

struct ContentView: View {
    @State private var gameGrid = GameGrid(size: GRID_SIZE)
    @State private var currentlySelectedCoordinates: [Coordinate] = []
    @State private var focusedCoordinate: Coordinate?
    @State private var selectionDirection: GeneralDirection?
    
    var body: some View {
        VStack {
            if let directionInstruction {
                Text(directionInstruction)
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
                    guard currentlySelectedCoordinates.count == 3 else { return }
                    gameGrid.placeShips(on: currentlySelectedCoordinates)
                    resetSelection()
                } label: {
                    Text("3S")
                }
                .buttonStyle(.borderedProminent)
                Button {
                    guard currentlySelectedCoordinates.count == 2 else { return }
                    gameGrid.placeShips(on: currentlySelectedCoordinates)
                    resetSelection()
                } label: {
                    Text("2S")
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Spacer()
                Button {
                    resetSelection()
                } label: {
                    Text("Reset Selection")
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Button {
                    clearGrid()
                } label: {
                    Text("Clear Grid")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .animation(.default, value: focusedCoordinate)
        .animation(.default, value: gameGrid)
        .animation(.default, value: currentlySelectedCoordinates)
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
