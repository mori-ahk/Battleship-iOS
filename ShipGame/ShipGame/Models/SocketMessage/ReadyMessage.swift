//
//  ReadyMessage.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import Foundation

struct ReadyMessage: Codable {
    let gameUuid: String
    let playerUuid: String
    let defenceGrid: [[Int]]
}
