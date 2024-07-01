//
//  Difficulty.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import Foundation

enum Difficulty: String, CaseIterable, Equatable, Identifiable {
    var id: String { rawValue }
    case easy
    case medium
    case hard
 
    var value: Int {
        switch self {
        case .easy: 0
        case .medium: 1
        case .hard: 2
        }
    }
    
    var size: Int {
        switch self {
        case .easy: 6
        case .medium: 7
        case .hard: 8
        }
    }
    
    var title: String {
        rawValue.capitalized
    }
    
    var sizeText: String {
        return "\(size) X \(size)"
    }
}
