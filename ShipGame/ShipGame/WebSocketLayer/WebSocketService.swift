//
//  WebsocketService.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-04.
//

import Foundation
import Combine

protocol WebSocketService {
    func connect()
    func send(_ message: WebSocketMessage)
    func receive()
    var responsePipeline: PassthroughSubject<ResponseMessage?, Never> { get set }
    var session: Session? { get set }
    var delegate: WebSocketManagerDelegate? { get set }
}

protocol WebSocketMessage: Codable { }
