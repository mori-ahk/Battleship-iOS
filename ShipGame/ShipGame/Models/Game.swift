//
//  Game.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import Foundation

struct Game: Codable {
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "game_uuid"
    }
}
