//
//  Player.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import Foundation

struct Player: Codable {
    let id: String
    let isHost: Bool
    let isTurn: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id = "player_uuid"
        case isHost
        case isTurn
    }
}
