//
//  SessionMessage.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-16.
//

import Foundation

struct SessionMessage: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "sessionId"
    }
}
