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
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    @Published var message: (any Codable)?
    
    func connect() {
        guard let url = URL(string: "ws://localhost:8080/battleship") else { return }
        var request = URLRequest(url: url)
        request.addValue("ws://", forHTTPHeaderField: "Origin")
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let message):
                switch message {
                case .string(let text):
                    print("receiving text: \(text)")
                    guard let data = text.data(using: .utf8) else { break }
                    do {
                        let packet = try decoder.decode(Packet.self, from: data)
                        guard let code = Code(packet: packet) else { break }
                        switch code {
                        case .create:
                            print(code)
                        case .invite:
                            let inviteMessage = try? decoder.decode(Message<InviteMessage>.self, from: data)
                            resultPipeline.send(inviteMessage)
                        case .join:
                            print(code)
                        }
                    } catch {
                        print(error)
                    }
                default:
                    break
                }
                receiveMessage()
            }
        }
    }
    
    func create() {
        let message = Message<Packet>(code: .create)
        guard let messageData = try? encoder.encode(message) else { return }
        guard let messageString = String(data: messageData, encoding: .utf8) else { return }
        sendMessage(messageString)
    }
    
    func join(gameId: String) {
        let message = Message<JoinMessage>(code: .join, payload: JoinMessage(gameUuid: gameId))
        guard let messageData = try? encoder.encode(message) else { return }
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
