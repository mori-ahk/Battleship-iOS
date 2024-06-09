//
//  ReadyView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-01.
//

import SwiftUI

struct ReadyView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    var body: some View {
        VStack {
            Text("Place your ships, and press ready when you're done")
            Button {
                viewModel.ready()
            } label: {
                Text("Ready")
            }
            .buttonStyle(.borderedProminent)
        }
        .font(.title2)
        .fontWeight(.semibold)
    }
}
