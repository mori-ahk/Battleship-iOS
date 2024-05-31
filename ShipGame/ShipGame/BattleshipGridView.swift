//
//  BattleshipGridView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import SwiftUI

fileprivate let MAX_SELECTION_COUNT: Int = 4
fileprivate let MAX_SHIPS_COUNT: Int = 3

struct BattleshipGridView: View {
    @Binding var currentlySelectedCoordinates: [Coordinate]
    @Binding var focusedCoordinate: Coordinate?
    @Binding var selectionDirection: GeneralDirection?
    var gameGrid: GameGrid
    
    var body: some View {
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
    }
    
    private func isFocusedCoordinate(_ row: Int, _ column: Int) -> Bool {
        if let focusedCoordinate {
            return focusedCoordinate.x == row && focusedCoordinate.y == column
        } else {
            return false
        }
    }
    
    private func isCurrentlySelected(_ coordinate: Coordinate) -> Bool {
        return currentlySelectedCoordinates.contains(coordinate)
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
    
    private func isValidSelection(x row: Int, y column: Int) -> Bool {
        guard let focusedCoordinate else { return false }
        if let selectionDirection {
            switch selectionDirection {
            case .vertical:
                if isValidNeighbour(
                    x: row,
                    y: column,
                    given: selectionDirection
                ) && focusedCoordinate.y - column == .zero { return true }
                return false
            case .horizontal:
                if isValidNeighbour(
                    x: row,
                    y: column,
                    given: selectionDirection
                ) && focusedCoordinate.x - row == .zero { return true }
                return false
            }
        } else {
            if abs(focusedCoordinate.x - row) == 1 && 
                focusedCoordinate.y - column == .zero { return true }
            if abs(focusedCoordinate.y - column) == 1 && 
                focusedCoordinate.x - row == .zero { return true }
            return false
        }
    }
   
    private func isValidNeighbour(
        x row: Int,
        y column: Int,
        given direction: GeneralDirection
    ) -> Bool {
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
    
}
