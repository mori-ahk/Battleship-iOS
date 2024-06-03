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
    
    mutating func placeShips(on selectedCoordinates: [Coordinate]) {
        for coordinate in selectedCoordinates {
            coordinates[coordinate.x][coordinate.y].state = .occupied
        }
        ships.append(Ship(coordinates: selectedCoordinates))
    }
    
    mutating func clear() {
        for row in 0 ..< size {
            for column in 0 ..< size {
                coordinates[row][column].reset()
            }
        }
        ships.removeAll(keepingCapacity: true)
    }
    
    func isOccupied(_ coordinate: Coordinate) -> Bool {
        return coordinates[coordinate.x][coordinate.y].state == .occupied
    }
    
    func shipAlreadyUsed(_ kind: Ship.Kind) -> Bool {
        ships.filter { $0.kind == kind }.count == 1
    }
}
