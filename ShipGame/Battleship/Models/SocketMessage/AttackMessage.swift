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
    let attackedCoordinate: Coordinate
    let sunkenShip: SunkenShipCounter
    let sunkenShipsCoordinates: [Coordinate]

    enum CodingKeys: String, CodingKey {
        case isTurn
        case positionState
        case x
        case y
        case sunkenShipsHost
        case sunkenShipsJoin
        case defenderSunkenShipsCoords
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isTurn = try container.decode(Bool.self, forKey: CodingKeys.isTurn)
        let positionStateRawValue = try container.decode(Int.self, forKey: CodingKeys.positionState)
        switch positionStateRawValue {
        case 1:
            self.positionState = .miss
        case 2:
            self.positionState = .hit
        default:
            self.positionState = nil
        }
        let x = try container.decode(Int.self, forKey: CodingKeys.x)
        let y = try container.decode(Int.self, forKey: CodingKeys.y)
        self.attackedCoordinate = Coordinate(x: x, y: y)
        let hostSunkenShipsCount = try container.decode(Int.self, forKey: CodingKeys.sunkenShipsHost)
        let joinSunkenShipsCount = try container.decode(Int.self, forKey: CodingKeys.sunkenShipsJoin)
        self.sunkenShip = SunkenShipCounter(host: hostSunkenShipsCount, join: joinSunkenShipsCount)
        self.sunkenShipsCoordinates = try container.decodeIfPresent(
            [Coordinate].self,
            forKey: CodingKeys.defenderSunkenShipsCoords
        ) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        return
    }
}
