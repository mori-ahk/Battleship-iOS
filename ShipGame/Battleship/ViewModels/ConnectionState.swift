//
//  ConnectionState.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-21.
//

import Foundation

enum ConnectionState: Int, Identifiable, Equatable {
    var id: Int { rawValue }
    case idle
    case connecting
    case connected
    case disconnecting
    case disconnected
    
    var inProgress: Bool {
        switch self {
        case .connecting, .disconnecting: return true
        default: return false
        }
    }
}
