//
//  ShipsButtonView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import SwiftUI

struct ShipsButtonView: View {
    var isDisabled: (Ship.Kind) -> Bool
    var onTap: (Ship.Kind) -> Void
    
    var body: some View {
        VStack {
            ForEach(Ship.Kind.allCases) { ship in
                Button {
                    onTap(ship)
                } label: {
                    Text(ship.name)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isDisabled(ship))
            }
        }
        .padding()
    }
}
