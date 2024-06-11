//
//  View+Extensions.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-09.
//

import SwiftUI

extension View {
    func flideOut(from: Edge, to: Edge) -> some View {
        self
            .transition(
                .asymmetric(
                    insertion: .move(edge: from),
                    removal: .move(edge: to).combined(with: .opacity)
                )
            )
    }
}
