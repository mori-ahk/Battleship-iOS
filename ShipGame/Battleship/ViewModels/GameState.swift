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
    case ended(GameResult)
}

extension GameState: Identifiable {
    var id: Int {
        switch self {
        case .idle: 0
        case .created(_): 1
        case .select: 2
        case .ready: 3
        case .started: 4
        case .attacked: 5
        case .ended: 6
        }
    }
    
    var modificationAllowed: Bool {
        switch self {
        case .ready, .started, .attacked: false
        default: true
        }
    }
}

extension GameState: Equatable {
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        lhs.id == rhs.id
    }
}
