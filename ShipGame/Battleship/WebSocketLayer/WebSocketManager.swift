//
//  WebSocketManager.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-27.
//

import SwiftUI
import Combine

class WebSocketManager: NSObject, ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private var endpoint: Endpoint {
        #if DEBUG
        return .debug
        #else
        return .production
        #endif
    }
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
            dprint("receiving text: \(text)")
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
            dprint(error)
        }
    }
    
    private func handleCode(_ code: Code, data: Data) {
        do {
            switch code {
            case .sessionId:
                try processSessionMessage(data)
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
                responsePipeline.send(.opponentStatus(.disconnected))
            case .opponentReconnected:
                responsePipeline.send(.opponentStatus(.reconnected))
            case .gracePeriod:
                responsePipeline.send(.opponentStatus(.gracePeriod))
            case .rematchRequested:
                responsePipeline.send(.rematchStatus(.requested))
            case .rematchAccepted:
                responsePipeline.send(.rematchStatus(.accepted))
            case .rematchRejected:
                responsePipeline.send(.rematchStatus(.rejected))
            case .rematch:
                try processRematchMessage(data)
            default:
                break
            }
        } catch {
            dprint(error)
        }
    }
  
    private func processSessionMessage(_ data: Data) throws {
        let sessionMessage = try decoder.decode(Message<SessionMessage>.self, from: data)
        guard let payload = sessionMessage.payload else { return }
        responsePipeline.send(.session(payload))
    }
    
    private func processCreateMessage(_ data: Data) throws {
        let createMessage = try decoder.decode(Message<RespCreateMessage>.self, from: data)
        guard let payload = createMessage.payload, let gameInfo = GameInfo(payload) else { return }
        responsePipeline.send(.create(gameInfo))
    }
    
    private func processJoinMessage(_ data: Data) throws {
        let joinMessage = try decoder.decode(Message<JoinMessage>.self, from: data)
        guard let payload = joinMessage.payload else { return }
        responsePipeline.send(.join(payload, joinMessage.error))
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
    
    private func processRematchMessage(_ data: Data) throws {
        let rematchMessage = try decoder.decode(Message<RematchMessage>.self, from: data)
        guard let payload = rematchMessage.payload else { return }
        responsePipeline.send(.rematch(payload))
    }
}

extension WebSocketManager: WebSocketService {
    func ping() async -> Bool {
        await withCheckedContinuation { continuation in
            webSocketTask?.sendPing(pongReceiveHandler: { error in
                continuation.resume(returning: error == nil)
            })
        }
    }
    
    func connect(to sessionId: String?) {
        var components = URLComponents(string: endpoint.url)
        components?.queryItems = [
            URLQueryItem(name: "sessionID", value: sessionId)
        ]
        guard let url = components?.url else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: URLRequest(url: url))
        webSocketTask?.delegate = self
        webSocketTask?.resume()
    }
   
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func send(_ message: WebSocketMessage) {
        dprint("sending: \(message)")
        guard let messageString = jsonString(of: message) else { return }
        webSocketTask?.send(.string(messageString)) { error in
            if let error = error {
                dprint(error.localizedDescription)
            }
        }
    }
    
    func receive() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                dprint(error.localizedDescription)
                
            case .success(let message):
                self.handleMessage(message)
                self.receive()
            }
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        receive()
        delegate?.didConnect()
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        delegate?.didDisconnect()
    }
}

protocol WebSocketManagerDelegate: AnyObject {
    func didConnect()
    func didDisconnect()
}
