//
//  Code.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-06.
//

import Foundation

enum Code: Int, Codable {
    case sessionId = 0
    case invalidSessionId
    case create
    case join
    case select
    case ready
    case start
    case attack
    case end
    case invalid
    case absent
   
    enum CodingKeys: String, CodingKey {
        case code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let code = try container.decode(Int.self, forKey: .code)
        self = Code(rawValue: code)!
    }
}

