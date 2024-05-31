//
//  JoinMessage.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-12.
//

import Foundation

struct ReqJoinMessage: Codable {
    let gameUuid: String
}

struct RespJoinMessage: Codable {
    let playerUuid: String
}
