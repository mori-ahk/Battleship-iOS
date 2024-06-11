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
    var isTurn: Bool = false
    var isReady: Bool = false
}
