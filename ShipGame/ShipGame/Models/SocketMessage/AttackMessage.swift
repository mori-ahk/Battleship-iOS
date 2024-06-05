//
//  AttackMessage.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-02.
//

import Foundation

struct ReqAttackMessage: Codable {
    let gameUuid: String
    let playerUuid: String
    let x: Int
    let y: Int
}
