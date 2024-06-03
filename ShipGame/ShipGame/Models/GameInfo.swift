//
//  GameInfo.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import Foundation

struct GameInfo: Codable {
    var game: Game
    var playerUuid: String?
    
    init(gameId: String, playerUuid: String? = nil) {
        self.game = Game(id: gameId)
        self.playerUuid = playerUuid
    }
}
