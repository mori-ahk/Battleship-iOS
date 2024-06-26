//
//  Util.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-26.
//

import Foundation

public func dprint(_ object: Any...) {
    #if DEBUG
    Swift.print(object)
    #endif
}
