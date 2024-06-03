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
    @EnvironmentObject private var gameViewModel: GameViewModel
    @Binding var currentlySelectedCoordinates: [Coordinate]
    @Binding var focusedCoordinate: Coordinate?
    @Binding var selectionDirection: GeneralDirection?
    
    var body: some View {
        Grid {
            ForEach(0 ..< gameViewModel.gameGrid.size, id: \.self) { row in
                GridRow {
                    ForEach(0 ..< gameViewModel.gameGrid.size, id: \.self) { column in
                        let size: CGFloat = isFocusedCoordinate(row, column) ? 55 : 50
                        let coordinate: Coordinate = Coordinate(x: row, y: column)
                        Button {
                            guard currentlySelectedCoordinates.count != MAX_SELECTION_COUNT else { return }
                            guard !isCurrentlySelected(coordinate) else { return }
                            guard !gameViewModel.gameGrid.isOccupied(coordinate) else { return }
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
                                    if gameViewModel.gameGrid.isOccupied(coordinate) {
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
        focusedCoordinate?.x == row && focusedCoordinate?.y == column
    }
    
    private func isCurrentlySelected(_ coordinate: Coordinate) -> Bool {
        currentlySelectedCoordinates.contains(coordinate)
    }
    
    private func findDirection() -> GeneralDirection? {
        guard let lastSelectedCoordinate = currentlySelectedCoordinates.last,
              let firstSelectedCoordinate = currentlySelectedCoordinates.first else {
            return nil
        }
        
        if abs(lastSelectedCoordinate.x - firstSelectedCoordinate.x) == 1 {
            return .vertical
        }
        
        if abs(lastSelectedCoordinate.y - firstSelectedCoordinate.y) == 1 {
            return .horizontal
        }
        
        return nil
    }
    
    private func isValidSelection(x row: Int, y column: Int) -> Bool {
        guard let focusedCoordinate else { return false }
        if let direction = selectionDirection {
            return isValidNeighbour(x: row, y: column, given: direction) &&
            isAlignedWithDirection(
                focusedCoordinate,
                x: row,
                y: column,
                direction: direction
            )
        } else {
            return isAdjacent(focusedCoordinate, x: row, y: column)
        }
    }
   
    private func isValidNeighbour(
        x row: Int,
        y column: Int,
        given direction: GeneralDirection
    ) -> Bool {
        currentlySelectedCoordinates.contains { coordinate in
            switch direction {
            case .vertical:
                return abs(coordinate.x - row) == 1
            case .horizontal:
                return abs(coordinate.y - column) == 1
            }
        }
    }
    
    private func isAlignedWithDirection(
        _ coordinate: Coordinate,
        x row: Int,
        y column: Int,
        direction: GeneralDirection
    ) -> Bool {
        switch direction {
        case .vertical:
            return coordinate.y == column
        case .horizontal:
            return coordinate.x == row
        }
    }
    
    private func isAdjacent(
        _ coordinate: Coordinate,
        x row: Int,
        y column: Int
    ) -> Bool {
        (abs(coordinate.x - row) == 1 && coordinate.y == column) ||
        (abs(coordinate.y - column) == 1 && coordinate.x == row)
    }
}
