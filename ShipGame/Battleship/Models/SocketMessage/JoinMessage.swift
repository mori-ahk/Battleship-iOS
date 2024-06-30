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
    let gameDifficulty: Difficulty
    
    enum CodingKeys: String, CodingKey {
        case gameId = "gameUuid"
        case playerId = "playerUuid"
        case gameDifficulty = "gameDifficulty"
    }
   
    init(gameId: String) {
        self.gameId = gameId
        self.playerId = nil
        self.gameDifficulty = .easy
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gameId = try container.decode(String.self, forKey: .gameId)
        self.playerId = try container.decodeIfPresent(String.self, forKey: .playerId)
        let difficulty = try container.decode(Int.self, forKey: .gameDifficulty)
        switch difficulty {
        case 0:
            self.gameDifficulty = .easy
        case 1:
            self.gameDifficulty = .medium
        case 2:
            self.gameDifficulty = .hard
        default:
            self.gameDifficulty = .easy
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gameId, forKey: .gameId)
    }
}

