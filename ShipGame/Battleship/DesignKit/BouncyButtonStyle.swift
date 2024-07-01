//
//  BouncyButtonStyle.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct BouncyButtonStyle: ButtonStyle {
    var shadowColor: Color?
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .bounce(configuration.isPressed, shadowColor: shadowColor)
    }
}
