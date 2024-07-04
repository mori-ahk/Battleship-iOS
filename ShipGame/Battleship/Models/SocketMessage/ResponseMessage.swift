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
    case join(JoinMessage, MessageError?)
    case select
    case ready
    case start
    case attack(RespAttackMessage)
    case end(EndMessage)
    case opponentStatus(OpponentStatus)
    case rematchRequest
    case rematchResult(RematchResult)
}

enum OpponentStatus {
    case disconnected
    case reconnected
    case gracePeriod
}

enum RematchResult {
    case accepted
    case rejected
}
