//
//  CreateMessage.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-06.
//

import Foundation

struct RespCreateMessage: Codable {
    let gameUuid: String
    let hostUuid: String
}

struct ReqCreateMessage: Codable {
    let gameDifficulty: Int
}
