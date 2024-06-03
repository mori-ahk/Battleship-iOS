//
//  MessageView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-01.
//

import SwiftUI

struct MessageView: View {
    var message: MessageType?
    var isReady: Bool
    var onReady: (() -> Void)? = nil
    var body: some View {
        if let message {
            VStack {
                switch message {
                case .create(let gameUuid, _):
                    Text("Game Id: \(gameUuid)")
                case .join(_):
                    EmptyView()
                case .select:
                    VStack {
                        Text("Place your ships, and press ready when you're done")
                        Button {
                            onReady?()
                        } label: {
                            Text("Ready")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isReady)
                    }
                default: EmptyView()
                }
            }
            .font(.title2)
            .fontWeight(.semibold)
        }
    }
}
