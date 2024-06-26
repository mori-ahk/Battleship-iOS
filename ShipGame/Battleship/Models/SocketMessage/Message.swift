//
//  Message.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-06.
//

import Foundation

struct Message<T: Codable>: WebSocketMessage {
    var code: Code
    var payload: T?
    var error: MessageError?
   
    init(code: Code, payload: T? = nil) {
        self.code = code
        self.payload = payload
        self.error = nil
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Message<T>.CodingKeys> = try decoder.container(keyedBy: Message<T>.CodingKeys.self)
        let codeRawValue = try container.decode(Int.self, forKey: Message<T>.CodingKeys.code)
        self.code = Code(rawValue: codeRawValue)!
        self.payload = try container.decodeIfPresent(T.self, forKey: Message<T>.CodingKeys.payload)
        self.error = try container.decodeIfPresent(MessageError.self, forKey: Message<T>.CodingKeys.error)
    }
}

struct MessageError: Codable {
    let errorDetails: String?
    let message: String?
}
