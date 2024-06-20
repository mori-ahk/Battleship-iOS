//
//  WebSocketManager.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-27.
//

import SwiftUI
import Combine

class WebSocketManager: NSObject, ObservableObject {
    var session: Session? = nil
    private var webSocketTask: URLSessionWebSocketTask?
    var responsePipeline = PassthroughSubject<ResponseMessage?, Never>()
    var delegate: WebSocketManagerDelegate?
    
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
   
    private func jsonString<T: Codable>(of message: T) -> String? {
        guard let messageData = try? encoder.encode(message) else { return nil }
        return String(data: messageData, encoding: .utf8)
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            print("receiving text: \(text)")
            processTextMessage(text)
        default:
            break
        }
    }
    
    private func processTextMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        do {
            let code = try decoder.decode(Code.self, from: data)
            handleCode(code, data: data)
        } catch {
            print(error)
        }
    }
    
    private func handleCode(_ code: Code, data: Data) {
        do {
            switch code {
            case .sessionId:
                try processSessionMessage(data)
            case .invalidSessionId:
                responsePipeline.send(.invalidSession)
            case .create:
                try processCreateMessage(data)
            case .join:
                try processJoinMessage(data)
            case .select:
                responsePipeline.send(.select)
            case .ready:
                responsePipeline.send(.ready)
            case .start:
                responsePipeline.send(.start)
            case .attack:
                try processAttackMessage(data)
            case .end:
                try processEndMessage(data)
            case .opponentDisconnected:
                responsePipeline.send(.opponentConnectionChanged(.disconnected))
            case .opponentReconnected:
                responsePipeline.send(.opponentConnectionChanged(.reconnected))
            default:
                break
            }
            
        } catch {
            print(error)
        }
    }
   
    private func processSessionMessage(_ data: Data) throws {
        let sessionMessage = try decoder.decode(Message<SessionMessage>.self, from: data)
        guard let payload = sessionMessage.payload else { return }
        self.session = Session(id: payload.id)
        responsePipeline.send(.sessionId(session!))
    }
    
    private func processCreateMessage(_ data: Data) throws {
        let createMessage = try decoder.decode(Message<CreateMessage>.self, from: data)
        guard let payload = createMessage.payload, let gameInfo = GameInfo(payload) else { return }
        responsePipeline.send(.create(gameInfo))
    }
    
    private func processJoinMessage(_ data: Data) throws {
        let joinMessage = try decoder.decode(Message<JoinMessage>.self, from: data)
        guard let payload = joinMessage.payload else { return }
        responsePipeline.send(.join(payload))
    }
    
    private func processAttackMessage(_ data: Data) throws {
        let attackMessage = try decoder.decode(Message<RespAttackMessage>.self, from: data)
        guard let payload = attackMessage.payload else { return }
        responsePipeline.send(.attack(payload))
    }
    
    private func processEndMessage(_ data: Data) throws {
        let endMessage = try decoder.decode(Message<EndMessage>.self, from: data)
        guard let payload = endMessage.payload else { return }
        responsePipeline.send(.end(payload))
    }
}

extension WebSocketManager: WebSocketService {
    func ping() async -> Result<Bool, Error> {
        await withCheckedContinuation { continuation in
            webSocketTask?.sendPing(pongReceiveHandler: { error in
                if let error = error {
                    continuation.resume(returning: .failure(error))
                } else {
                    continuation.resume(returning: .success(true))
                }
            })
        }
    }
    
    func connect() {
        var components = URLComponents(string: "wss://battleship-go-ios.fly.dev/battleship")
//        var components = URLComponents(string: "ws://localhost:8080/battleship")
        if let sessionId = session?.id {
            components?.queryItems = [
                URLQueryItem(name: "sessionID", value: sessionId)
            ]
        }
       
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.delegate = self
        webSocketTask?.resume()
        receive()
    }
   
    func disconnect() {
        webSocketTask?.cancel()
    }
    
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
                self.handleMessage(message)
                self.receive()
            }
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        delegate?.didConnect()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        delegate?.didDisconnect()
    }
}

protocol WebSocketManagerDelegate: AnyObject {
    func didConnect()
    func didDisconnect()
}
