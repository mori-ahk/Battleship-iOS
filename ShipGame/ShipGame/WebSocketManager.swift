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
    var resultPipeline = PassthroughSubject<RespMessageType?, Never>()
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
                            guard let inviteMessage = try? decoder.decode(
                                Message<CreateMessage>.self,
                                from: data
                            ), let payload = inviteMessage.payload else { break }
                            resultPipeline.send(.create(payload.gameUuid, payload.hostUuid))
                        case .join:
                            guard let joinMessage = try? decoder.decode(
                                Message<RespJoinMessage>.self,
                                from: data
                            ), let payload = joinMessage.payload else { break }
                            resultPipeline.send(.join(payload.playerUuid))
                        case .select:
                            resultPipeline.send(.select)
                        case .start:
                            resultPipeline.send(.start)
                        default: break
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
        guard let messageString = jsonString(of: message) else { return }
        sendMessage(messageString)
    }
    
    func join(gameId: String) {
        let message = Message<ReqJoinMessage>(code: .join, payload: ReqJoinMessage(gameUuid: gameId))
        guard let messageString = jsonString(of: message) else { return }
        sendMessage(messageString)
    }
   
    func ready(_ message: ReadyMessage) {
        let message = Message<ReadyMessage>(code: .ready, payload: message)
        guard let messageString = jsonString(of: message) else { return }
        sendMessage(messageString)
    }
   
    func attack(_ message: ReqAttackMessage) {
        let message = Message<ReqAttackMessage>(code: .attack, payload: message)
        guard let messageString = jsonString(of: message) else { return }
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
    
    private func jsonString<T: Codable>(of message: T) -> String? {
        guard let messageData = try? encoder.encode(message) else { return nil }
        return String(data: messageData, encoding: .utf8)
    }
}
