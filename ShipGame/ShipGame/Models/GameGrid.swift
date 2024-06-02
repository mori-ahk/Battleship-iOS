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
    
    func validDirection(for coordinate: Coordinate) -> [Direction] {
        let x = coordinate.x
        let y = coordinate.y
       
        // Top Leading Corner
        if x == .zero && y == .zero {
            return [.right, .down]
        }
        
        // Bottom Leading Corner
        if x == size - 1 && y == .zero {
            return [.right, .up]
        }
       
        // Top Trailing Corner
        if x == .zero && y == size - 1 {
            return [.left, .down]
        }
        
        // Bottom Trailing Corner
        if x == size - 1 && y == size - 1 {
            return [.left, .up]
        }
        
        // Top Row
        if x == .zero {
            return [.left, .right, .down]
        }
       
        // Bottom row {
        if x == size - 1 {
            return [.left, .right, .up]
        }
        
        // First column
        if y == .zero {
            return [.up, .down, .right]
        }
       
        // Last column
        if y == size - 1 {
            return [.up, .down, .left]
        }
       
        return Direction.allCases
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

struct Coordinate: Equatable {
    let x: Int
    let y: Int
    var state: State = .empty
    enum State: Int {
        case empty = 0
        case occupied
        case hit
        case miss
    }
    
    mutating func reset() {
        state = .empty
    }
}

struct Ship: Equatable {
    var coordinates: [Coordinate]
    
    init(coordinates: [Coordinate]) {
        self.coordinates = coordinates
        for (index, _) in self.coordinates.enumerated() {
            self.coordinates[index].state = .occupied
        }
    }
    
    var isSunk: Bool {
        coordinates.allSatisfy { $0.state == .hit }
    }
    
    var kind: Kind? {
        switch coordinates.count {
        case 4: return .battleShip
        case 3: return .cruiser
        case 2: return .destroyer
        default: return nil
        }
    }
    
    enum Kind: String, CaseIterable, Identifiable {
        var id: String { name }
        case battleShip
        case cruiser
        case destroyer
        
        var size: Int {
            switch self {
            case .battleShip:
                return 4
            case .cruiser:
                return 3
            case .destroyer:
                return 2
            }
        }
        
        var name: String {
            "\(rawValue.capitalized) (\(size.description))"
        }
    }
}

enum Direction: String, CaseIterable {
    case left
    case up
    case right
    case down
    
    var description: String { rawValue }
}
