//
//  Coordinate.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-03.
//

import Foundation

struct Coordinate: Equatable, Decodable {
    let x: Int
    let y: Int
    var state: State = .empty

    enum CodingKeys: String, CodingKey {
        case x, y
    }
   
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(Int.self, forKey: CodingKeys.x)
        self.y = try container.decode(Int.self, forKey: CodingKeys.y)
        self.state = .empty
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.state = .empty
    }
    
    enum State: Equatable {
        case empty
        case occupied(Ship.Kind)
        case hit
        case miss
        case sunk
        
        var value: Int {
            switch self {
            case .empty: 0
            case .occupied(let ship): ship.size
            case .hit: 5
            case .miss: 6
            case .sunk: 7
            }
        }
        
        var isOccupied: Bool {
            switch self {
            case .occupied(_): true
            default: false
            }
        }
        
        var description: String {
            switch self {
            case .empty: return "Empty"
            case .occupied: return "Occupied"
            case .hit: return "Hit"
            case .miss: return "Miss"
            case .sunk: return "Sunk"
            }
        }
        
        var sign: String? {
            switch self {
            case .hit: "🔥"
            case .miss: "🫤"
            case .occupied(let ship): ship.sign
            default: nil
            }
        }
        
        var size: CGFloat {
            switch self {
            case .hit: 40
            case .miss: 30
            case .empty: 35
            case .occupied: 40
            case .sunk: 10
            }
        }
    }
}

extension Coordinate {
    mutating func reset() { state = .empty }
    func isOccupied() -> Bool { state.isOccupied }
}
