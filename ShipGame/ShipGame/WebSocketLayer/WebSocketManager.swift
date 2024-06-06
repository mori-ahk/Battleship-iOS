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
    var responsePipeline = PassthroughSubject<ResponseMessage?, Never>()
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
            case .create:
                try processCreateMessage(data)
            case .join:
                try processJoinMessage(data)
            case .select:
                responsePipeline.send(.select)
            case .start:
                responsePipeline.send(.start)
            default:
                break
            }
            
        } catch {
            print(error)
        }
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
}

extension WebSocketManager: WebSocketService {
    func connect() {
        guard let url = URL(string: "ws://localhost:8080/battleship") else { return }
        var request = URLRequest(url: url)
        request.addValue("ws://", forHTTPHeaderField: "Origin")
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receive()
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
