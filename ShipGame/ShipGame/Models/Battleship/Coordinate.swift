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
    
    enum State: Int {
        case empty = 0
        case occupied
        case hit
        case miss
    }
}

extension Coordinate {
    mutating func reset() { state = .empty }
    func isOccupied() -> Bool { state == .occupied }
}
