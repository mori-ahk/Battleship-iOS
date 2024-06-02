//
//  MessageView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-01.
//

import SwiftUI

struct MessageView: View {
    var message: MessageType?
    var action: (() -> Void)? = nil
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
                        Text("Select your grid and press ready.")
                        Button {
                           action?()
                        } label: {
                            Text("Ready")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .font(.title2)
            .fontWeight(.semibold)
        }
    }
}
