//
//  Message.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-06.
//

import Foundation

struct Message<T: Codable>: Codable {
    var code: Code
    var payload: T?
    var error: MessageError?
}

struct MessageError: Codable {
    let errorDetails: String
    let message: String
}
