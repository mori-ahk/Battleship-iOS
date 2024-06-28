//
//  BouncyButtonViewModifier.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct BouncyButtonViewModifier: ViewModifier {
    var isPressed: Bool
    var shadowColor: Color?
    
    func body(content: Content) -> some View {
        if let shadowColor {
            content
                .shadow(color: shadowColor, radius: UXMetrics.shadowRedius)
                .scaleWithAnimation(isPressed)
        } else {
            content
                .scaleWithAnimation(isPressed)
        }
    }
}

extension View {
    func bounce(_ isPressed: Bool, shadowColor: Color? = nil) -> some View {
        modifier(BouncyButtonViewModifier(isPressed: isPressed, shadowColor: shadowColor))
    }
}
