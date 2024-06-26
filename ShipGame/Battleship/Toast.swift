//
//  Toast.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-26.
//

import SwiftUI

struct Toast: Equatable {
    let title: String
    let style: ToastStyle
}

enum ToastStyle {
    case success
    case error
    
    var icon: String {
        switch self {
        case .success: "checkmark"
        case .error: "xmark"
        }
    }
    
    var color: Color {
        switch self {
        case .success: .green
        case .error: .red
        }
    }
}
