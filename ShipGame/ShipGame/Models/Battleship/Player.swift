//
//  Player.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import Foundation

struct Player {
    let id: String
    let isHost: Bool
    var isTurn: Bool
    var isReady: Bool
    
    init(id: String, isHost: Bool, isTurn: Bool = false, isReady: Bool = false) {
        self.id = id
        self.isHost = isHost
        self.isTurn = isTurn
        self.isReady = isReady
    }
}
