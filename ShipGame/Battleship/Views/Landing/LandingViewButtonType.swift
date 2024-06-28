//
//  LandingViewButtonType.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import Foundation

enum LandingViewButtonType: CaseIterable, Identifiable {
    var id: String { title }
    case create
    case join
    
    var title: String {
        switch self {
        case .create: "Create a game"
        case .join: "Join a game"
        }
    }
    
    var width: CGFloat { 180 }
    var height: CGFloat { 40 }
}
