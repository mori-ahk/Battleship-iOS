//
//  Code.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-06.
//

import Foundation

enum Code: Int, Codable {
    case create = 0
    case join
    
    init?(packet: Packet?) {
        if let packet, let code = Code(rawValue: packet.code) {
            self = code
        } else { return nil }
    }
}

