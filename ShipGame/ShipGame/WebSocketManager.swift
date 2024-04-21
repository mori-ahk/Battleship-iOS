//
//  WebSocketManager.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-27.
//

import SwiftUI
import Combine

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    var resultPipeline = PassthroughSubject<IncomingMessage<InviteMessage>?, Never>()
    @Published var message: (any Codable)?
    
    private func connect() {
        guard let url = URL(string: "ws://127.0.0.1:3000/cable") else { return }
        var request = URLRequest(url: url)
        request.addValue("ws://", forHTTPHeaderField: "Origin")
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let message):
                    switch message {
                    case .string(let text):
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dataDecodingStrategy = .base64
                        print("receiving text: \(text)")
                        guard let data = text.data(using: .utf8) else { break }
                        if (try? decoder.decode(PingPacket.self, from: data)) != nil { break }
                        do {
                            let transmittedData = try decoder.decode(TransmittedData.self, from: data)
                            guard let action = Action(packet: transmittedData.message) else { break }
                            switch action {
                            case .invite:
                                let inviteMessage = try? JSONDecoder().decode(IncomingMessage<InviteMessage>.self, from: data)
                                self.resultPipeline.send(inviteMessage)
                            case .select:
                                print(action)
                            }
                        } catch {
                            print(error)
                        }
                    case .data(let data):
                        print("receiving data: \(data)")
                        break
                    @unknown default:
                        break
                    }
                    self.receiveMessage()
                }
            }
        }
    }
    
    func subscribe() {
        self.connect()
        let message = message(.subscribe)
        guard let messageData = try? JSONSerialization.data(withJSONObject: message) else { return }
        guard let messageString = String(data: messageData, encoding: .utf8) else { return }
        sendMessage(messageString)
    }
    
    func sendMessage(_ message: String) {
        print("sending: \(message)")
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
   
    func join(to roomId: String) {
        let message = payload(.message, data: JoinMessage(roomId: roomId))
        guard let messageData = try? JSONSerialization.data(withJSONObject: message) else { return }
        guard let messageString = String(data: messageData, encoding: .utf8) else { return }
        sendMessage(messageString)
    }
    
    func ready(to roomId: String, from playerId: String) {
        
    }
    
    
    private func identifierJsonString() -> String {
        let identifier = Channel(channel: "RoomChannel")
        guard let identifierData = try? JSONEncoder().encode(identifier) else { return "" }
        guard let identifierString = String(data: identifierData, encoding: .utf8) else { return "" }
        return identifierString
    }
    
    private func message(_ command: Command) -> [String : Any] {
        return [
            "command": command.text,
            "identifier": identifierJsonString(),
        ] as [String : Any]
    }
    
    private func payload(_ command: Command, data: Encodable) -> [String : Any] {
        guard let data = try? JSONEncoder().encode(data) else { return [:] }
        guard let dataString = String(data: data, encoding: .utf8) else { return [:] }
        return [
            "command": command.text,
            "identifier": identifierJsonString(),
            "data": dataString
        ] as [String : Any]
    }
}

struct Message<T: Codable>: Codable {
    var action: Action
    var payload: T
}

struct Packet: Codable {
    var action: Int
}

enum Action: Int, Codable {
    case invite = 0
    case select = 1
    
    init?(packet: Packet?) {
        if let packet, let action = Action(rawValue: packet.action) {
            self = action
        } else { return nil }
    }
}

enum Command: Encodable {
    case subscribe
    case unsubscribe
    case message
    
    var text: String {
        switch self {
        case .subscribe:
            return "subscribe"
        case .unsubscribe:
            return "unsubscribe"
        case .message:
            return "message"
        }
    }
}

struct RoomId: Encodable {
    let roomId = UUID()
}

struct Channel: Codable {
    var channel: String
}

struct JoinMessage: Encodable {
    let command: String = "join"
    let roomId: String
}

struct InviteMessage: Codable {
    var roomId: String
}

struct TransmittedData: Codable {
    let identifier: String
    let message: Packet
}

struct IncomingMessage<T: Codable>: Codable {
    let message: Message<T>
}

struct PingPacket: Codable {
    let type: String
    let message: Double
}
