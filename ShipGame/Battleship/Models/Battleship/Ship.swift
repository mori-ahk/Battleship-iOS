//
//  Ship.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-03.
//

import SwiftUI

struct Ship: Equatable {
    var coordinates: [Coordinate]
    var kind: Ship.Kind
    init(coordinates: [Coordinate], kind: Ship.Kind) {
        self.coordinates = coordinates
        self.kind = kind
        for (index, _) in self.coordinates.enumerated() {
            self.coordinates[index].state = .occupied(kind)
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
        
        var sign: String {
            "\(String(describing: rawValue.capitalized.first!))"
        }
        
        var color: Color {
            switch self {
            case .battleShip:
                return .aqua
            case .cruiser:
                return .minty
            case .destroyer:
                return .deepSkyBlue
            }
        }
    }
}

extension Ship {
    var isSunk: Bool {
        coordinates.allSatisfy { $0.state == .hit }
    }
}
