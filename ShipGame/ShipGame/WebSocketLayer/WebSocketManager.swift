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
        receive()
    }
    
    func create() {
        let message = Message<Packet>(code: .create)
        send(message)
    }
    
    func join(gameId: String) {
        let message = Message<JoinMessage>(
            code: .join,
            payload: JoinMessage(gameId: gameId, playerId: nil)
        )
        send(message)
    }
   
    func ready(_ message: ReadyMessage) {
        let message = Message<ReadyMessage>(code: .ready, payload: message)
        send(message)
    }
   
    func attack(_ message: ReqAttackMessage) {
        let message = Message<ReqAttackMessage>(code: .attack, payload: message)
        send(message)
    }
    
    private func jsonString<T: Codable>(of message: T) -> String? {
        guard let messageData = try? encoder.encode(message) else { return nil }
        return String(data: messageData, encoding: .utf8)
    }
}

extension WebSocketManager: WebSocketService {
    func send(_ message: WebSocketMessage) {
        print("sending: \(message)")
        guard let messageString = jsonString(of: message) else { return }
        webSocketTask?.send(.string(messageString)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func receive() {
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
                            guard let createMessage = try? decoder.decode(
                                Message<CreateMessage>.self,
                                from: data
                            ), let payload = createMessage.payload else { break }
                            resultPipeline.send(
                                .create(
                                    GameInfo(
                                        gameId: payload.gameUuid,
                                        playerId: payload.hostUuid
                                    )
                                )
                            )
                        case .join:
                            let joinMessage = try decoder.decode(
                                Message<JoinMessage>.self,
                                from: data
                            )
                            guard let payload = joinMessage.payload else { break }
                            resultPipeline.send(
                                .join(
                                    JoinMessage(
                                        gameId: payload.gameId,
                                        playerId: payload.playerId
                                    )
                                )
                            )
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
                receive()
            }
        }
    }
}
