//
//  BattleshipInterface.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-06.
//

import Foundation

protocol BattleshipInterface {
    func connect(source: ConnectionSource)
    func disconnect()
    func create()
    func join(game: Game)
    func ready()
    func attack(coordinate: Coordinate)
}
