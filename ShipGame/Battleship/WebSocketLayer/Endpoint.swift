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
    
    var url: String {
        switch self {
        case .debug:
            return "wss://battleship-go-ios-staging.fly.dev/battleship"
        case .production:
            return "wss://battleship-go-ios.fly.dev/battleship"
        }
    }
}
