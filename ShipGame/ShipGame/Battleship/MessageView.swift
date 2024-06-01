//
//  MessageView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-06-01.
//

import SwiftUI

struct MessageView: View {
    var message: MessageType?
    
    var body: some View {
        if let message {
            VStack {
                switch message {
                case .create(let gameUuid, _):
                    Text("Game Id: \(gameUuid)")
                case .join(_):
                    EmptyView()
                case .select:
                    Text("Select your grid")
                }
            }
            .font(.title2)
            .fontWeight(.semibold)
        }
    }
}
