//
//  GameInfo.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import Foundation

struct GameInfo: Codable {
    var gameUuid: String?
    var playerUuid: String?
    
    init(gameUuid: String? = nil, playerUuid: String? = nil) {
        self.gameUuid = gameUuid
        self.playerUuid = playerUuid
    }
}
