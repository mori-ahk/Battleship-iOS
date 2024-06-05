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
    case playerJoined(Player)
    case ready
}

extension GameState: Identifiable {
    var id: Int {
        switch self {
        case .idle: 0
        case .created(_): 1
        case .playerJoined(_): 2
        case .ready: 3
        }
    }
}

extension GameState: Equatable {
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        lhs.id == rhs.id
    }
}
