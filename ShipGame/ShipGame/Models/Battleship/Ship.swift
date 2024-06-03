//
//  Ship.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-03.
//

import Foundation

struct Ship: Equatable {
    var coordinates: [Coordinate]
    
    init(coordinates: [Coordinate]) {
        self.coordinates = coordinates
        for (index, _) in self.coordinates.enumerated() {
            self.coordinates[index].state = .occupied
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

extension Ship {
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
}
