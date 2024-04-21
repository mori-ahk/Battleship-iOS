//
//  LandingView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var landingViewModel = LandingViewModel()
    @State private var shouldShowGrid: Bool = false
    
    var body: some View {
        ZStack {
            if !shouldShowGrid {
                VStack {
                    Button {
                        landingViewModel.createGame()
                    } label: {
                        Text("Create")
                    }
                }
            } else {
                if let roomId = landingViewModel.roomId {
                    GridView(roomId: roomId)
                }
            }
        }
        .onReceive(landingViewModel.$roomId) { roomId in
            guard let roomId else { return }
            self.shouldShowGrid = true
        }
        .animation(.default, value: shouldShowGrid)
    }
}
