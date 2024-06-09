//
//  Coordinate.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-03.
//

import Foundation

struct Coordinate: Equatable {
    let x: Int
    let y: Int
    var state: State = .empty
    
    enum State: Equatable {
        case empty
        case occupied(Ship.Kind)
        case hit
        case miss
        
        var value: Int {
            switch self {
            case .empty: 0
            case .occupied(let ship): ship.size
            case .hit: 2
            case .miss: 3
            }
        }
        
        var isOccupied: Bool {
            switch self {
            case .occupied(_): true
            default: false
            }
        }
    }
}

extension Coordinate {
    mutating func reset() { state = .empty }
    func isOccupied() -> Bool { state.isOccupied }
}
