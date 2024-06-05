//
//  MessageType.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import Foundation

enum RespMessageType {
    case create(GameInfo)
    case join(JoinMessage)
    case select
    case start
}

enum ReqMessageType {
    case create
    case join(JoinMessage)
    case ready(ReadyMessage)
    case start
}
