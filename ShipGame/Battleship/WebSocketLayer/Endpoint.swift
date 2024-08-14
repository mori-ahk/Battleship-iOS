//
//  Endpoint.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-26.
//

import Foundation

enum Endpoint {
    case debug
    case production
    
    #error("Make sure to place the correct server URL below. Note that the URL should start with 'ws' or 'wss'")
    var url: String {
        switch self {
        case .debug:
            return "" // Debug URL
        case .production:
            return "" // Production URL
        }
    }
}
