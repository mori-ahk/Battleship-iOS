//
//  Instruction.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import Foundation

struct Instruction: Identifiable, Equatable {
    var id: String { description }
    let description: String
    
    static let all: [Instruction] = [
        .init(description: "Placing your ships on the grid board vertically or horizontally, but not diagonally. Ships cannot overlap or extend off the grid"),
        .init(description: "Once all ships are placed, players take turns guessing coordinates on their opponent's grid to try and hit and sink their ships"),
        .init(description: "When all squares occupied by a ship have been hit, that ship is considered sunk."),
        .init(description: "The game continues until one player sinks all of their opponent's ships")
        
    ]
}
