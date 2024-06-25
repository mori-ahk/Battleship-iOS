//
//  WebsocketService.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-04.
//

import Foundation
import Combine

protocol WebSocketService {
    func ping() async -> Bool
    func connect(to sessionId: String?)
    func disconnect()
    func send(_ message: WebSocketMessage)
    func receive()
    var responsePipeline: PassthroughSubject<ResponseMessage?, Never> { get set }
    var delegate: WebSocketManagerDelegate? { get set }
}

protocol WebSocketMessage: Codable { }
