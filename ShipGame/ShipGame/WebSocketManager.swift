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
    var resultPipeline = PassthroughSubject<Message<InviteMessage>?, Never>()
    @Published var message: (any Codable)?
    
    func connect() {
        guard let url = URL(string: "ws://localhost:9191/battleship") else { return }
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
                        print("receiving text: \(text)")
                        guard let data = text.data(using: .utf8) else { break }
                        do {
                            let packet = try decoder.decode(Packet.self, from: data)
                            guard let code = Code(packet: packet) else { break }
                            switch code {
                            case .invite:
                                let inviteMessage = try? decoder.decode(Message<InviteMessage>.self, from: data)
                                self.resultPipeline.send(inviteMessage)
                            case .create:
                                print(code)
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
    
    func create() {
        let message = Message<Packet>(code: .create)
        guard let messageData = try? JSONEncoder().encode(message) else { return }
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
}

struct Message<T: Codable>: Codable {
    var code: Code
    var payload: T?
}

struct Packet: Codable {
    var code: Int
}

enum Code: Int, Codable {
    case create = 0
    case invite = 1
    
    init?(packet: Packet?) {
        if let packet, let code = Code(rawValue: packet.code) {
            self = code
        } else { return nil }
    }
}

struct InviteMessage: Codable {
    let gameUuid: String
    let hostUuid: String
}

