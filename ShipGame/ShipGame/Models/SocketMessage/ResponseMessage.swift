//
//  MessageType.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import Foundation

enum ResponseMessage {
    case create(GameInfo)
    case join(JoinMessage)
    case select
    case ready
    case start
    case attack(RespAttackMessage)
    case end(EndMessage)
}

