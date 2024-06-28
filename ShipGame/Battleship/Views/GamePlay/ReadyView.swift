//
//  ReadyView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-01.
//

import SwiftUI

struct ReadyView: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @State private var shouldEnableReady: Bool = false
    var body: some View {
        VStack {
            Text("Place your ships, and press ready when you're done")
                .font(.title3)
                .fontWeight(.semibold)
            Button {
                viewModel.ready()
            } label: {
                Text("Ready")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!shouldEnableReady)
        }
        .animation(.default, value: shouldEnableReady)
        .onReceive(viewModel.$shouldEnableReady) { output in
            self.shouldEnableReady = output
        }
        .padding()
    }
}
