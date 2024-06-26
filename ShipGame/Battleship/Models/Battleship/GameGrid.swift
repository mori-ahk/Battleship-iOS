//
//  GameGrid.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-18.
//

import Foundation

fileprivate let GRID_SIZE: Int = 5

struct GameGrid: Equatable {
    let size: Int
    var coordinates: [[Coordinate]]
    var ships: [Ship] = []
    
    init(size: Int = GRID_SIZE) {
        self.size = size
        self.coordinates = Array(repeating: [], count: size)
        for row in 0 ..< size {
            for column in 0 ..< size {
                coordinates[row].append(Coordinate(x: row, y: column))
            }
        }
    }
}

extension GameGrid {
    mutating func placeShips(on selectedCoordinates: [Coordinate], kind: Ship.Kind) {
        for coordinate in selectedCoordinates {
            coordinates[coordinate.x][coordinate.y].state = .occupied(kind)
        }
        ships.append(Ship(coordinates: selectedCoordinates, kind: kind))
    }
    
    mutating func clear() {
        for row in 0 ..< size {
            for column in 0 ..< size {
                coordinates[row][column].reset()
            }
        }
        ships.removeAll(keepingCapacity: true)
    }
    
    mutating func setCoordinateState(
        at coordinate: Coordinate,
        to newState: Coordinate.State?,
        _ sunkenShipsCoordinates: [Coordinate]
    ) {
        coordinates[coordinate.x][coordinate.y].state = newState ?? .empty
        if !sunkenShipsCoordinates.isEmpty {
            for sunkenShipsCoordinate in sunkenShipsCoordinates {
                coordinates[sunkenShipsCoordinate.x][sunkenShipsCoordinate.y].state = .sunk
            }
        }
    }
    
    func isOccupied(_ coordinate: Coordinate) -> Bool {
        return coordinates[coordinate.x][coordinate.y].isOccupied()
    }
    
    func shipAlreadyUsed(_ kind: Ship.Kind) -> Bool {
        !ships.filter { $0.kind == kind }.isEmpty
    }
    
    func state(at coordinate: Coordinate) -> Coordinate.State {
        coordinates[coordinate.x][coordinate.y].state
    }
        
    func didPlaceAllShips() -> Bool {
        ships.count == 3
    }
}
