//
//  MessageType.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import Foundation

enum ResponseMessage {
    case session(SessionMessage)
    case create(GameInfo)
    case join(JoinMessage)
    case select
    case ready
    case start
    case attack(RespAttackMessage)
    case end(EndMessage)
    case opponentStatus(OpponentStatus)
}

enum OpponentStatus {
    case disconnected
    case reconnected
    case gracePeriod
}
