//
//  WebSocketManager.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-27.
//

import SwiftUI

@MainActor
class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var texts: String = ""
    init() {
        self.connect()
        let message = message(.subscribe)
        guard let messageData = try? JSONSerialization.data(withJSONObject: message) else { return }
        guard let messageString = String(data: messageData, encoding: .utf8) else { return }
        
        sendMessage(messageString)
    }
    
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
                    self.texts = error.localizedDescription
                case .success(let message):
                    switch message {
                    case .string(let text):
                        print("receiving text: \(text)")
                    case .data(let data):
                        print("receiving data: \(data)")
                        let message = try? JSONDecoder().decode(Message.self, from: data)
                        if let signal = Signal(message: message) {
                            switch signal {
                            case .select:
                                print(signal)
                            }
                        }
                        
                        break
                    @unknown default:
                        self.texts = "unknown default"
                        break
                    }
                    self.receiveMessage()
                }
            }
            
        }
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

struct Message: Codable {
    var message: Int
}

enum Signal: Int, Codable {
    case select = 0
    
    init?(message: Message?) {
        if let message, let signal = Signal(rawValue: message.message) {
            self = signal
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

struct Channel: Encodable {
    var channel: String
}

struct JoinMessage: Encodable {
    let command: String = "join"
    let roomId: String
}

struct S: Codable {
    let type: String
    let message: Double? = .zero
}
