//
//  WebsocketService.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-04.
//

import Foundation

protocol WebSocketService {
    func send(_ message: WebSocketMessage)
    func receive()
}

protocol WebSocketMessage: Codable { }
