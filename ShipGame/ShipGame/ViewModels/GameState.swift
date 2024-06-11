//
//  GameState.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-04.
//

import Foundation

enum GameState {
    case idle
    case created(Game)
    case select
    case ready
    case started
    case attacked(AttackResult)
}

extension GameState: Identifiable {
    var id: Int {
        switch self {
        case .idle: 0
        case .created(_): 1
        case .select: 2
        case .ready: 3
        case .started: 4
        case .attacked(_): 5
        }
    }
    
    var modificationAllowed: Bool {
        switch self {
        case .ready, .started, .attacked(_): false
        default: true
        }
    }
}

extension GameState: Equatable {
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        lhs.id == rhs.id
    }
}
