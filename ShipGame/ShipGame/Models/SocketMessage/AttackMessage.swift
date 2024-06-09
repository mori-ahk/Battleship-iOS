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

struct RespAttackMessage: Codable {
    let isTurn: Bool
    let positionState: Coordinate.State?

    enum CodingKeys: String, CodingKey {
        case isTurn
        case positionState
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isTurn = try container.decode(Bool.self, forKey: CodingKeys.isTurn)
        let positionStateRawValue = try container.decode(Int.self, forKey: CodingKeys.positionState)
        switch positionStateRawValue {
        case 1:
            self.positionState = .hit
        case -1:
            self.positionState = .miss
        default:
            self.positionState = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        return
    }
}
