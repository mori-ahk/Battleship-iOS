//
//  JoinMessage.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-12.
//

import Foundation

struct JoinMessage: Codable {
    let gameId: String
    let playerId: String?
    
    private enum CodingKeys: String, CodingKey {
        case gameId = "game_uuid"
        case playerId = "player_uuid"
    }
}

