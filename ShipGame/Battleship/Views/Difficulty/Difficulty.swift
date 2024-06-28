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
    case normal
    case hard
   
    var size: Int {
        switch self {
        case .easy: 6
        case .normal: 7
        case .hard: 8
        }
    }
    
    var title: String {
        rawValue.capitalized
    }
}
