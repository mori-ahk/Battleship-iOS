//
//  AnimatedButtonScale.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct AnimatedButtonScale: ViewModifier {
    var value: Bool
    func body(content: Content) -> some View {
        content
            .scaleEffect(
                value ? UXMetrics.buttonScaleWhenPressed : UXMetrics.buttonScaleWhenUnpressed
            )
            .animation(.easeIn(duration: 0.15), value: value)
    }
}

extension View {
    func scaleWithAnimation(_ value: Bool) -> some View {
        modifier(AnimatedButtonScale(value: value))
    }
}
