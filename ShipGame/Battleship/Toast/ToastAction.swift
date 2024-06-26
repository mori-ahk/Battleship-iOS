//
//  ToastAction.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-26.
//

import Foundation

enum ToastAction: Equatable {
    case copy
    
    var title: String {
        switch self {
        case .copy: "Copied to clipboard"
        }
    }
}
