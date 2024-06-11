//
//  View+Extensions.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-09.
//

import SwiftUI

extension View {
    func flideOut() -> some View {
        self
            .transition(
                .asymmetric(
                    insertion: .move(edge: .top),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                )
            )
    }
}
