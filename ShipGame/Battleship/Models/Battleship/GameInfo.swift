//
//  GameInfo.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import Foundation

struct GameInfo {
    var game: Game
    var player: Player?
    
    init(gameId: String, playerId: String? = nil, isHost: Bool = false) {
        self.game = Game(id: gameId)
        if let playerId {
            self.player = Player(id: playerId, isHost: isHost)
        }
    }
    
    init?(_ createMessage: RespCreateMessage?) {
        guard let createMessage else { return nil }
        self.game = Game(id: createMessage.gameUuid)
        self.player = Player(id: createMessage.hostUuid, isHost: true, isTurn: true)
    }
}
