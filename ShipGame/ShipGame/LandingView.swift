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
    @State private var shouldShowRoomIdAlert: Bool = false
    @State private var roomId: String = String()
    
    var body: some View {
        ZStack {
            if !shouldShowGrid {
                VStack {
                    Button {
                        landingViewModel.createGame()
                    } label: {
                        Text("Create")
                    }
                    Button {
                        shouldShowRoomIdAlert = true
                    } label: {
                        Text("Join")
                    }
                }
            } else {
                if let roomId = landingViewModel.roomId {
                    GridView(roomId: roomId)
                }
            }
        }
        .alert("Enter room Id", isPresented: $shouldShowRoomIdAlert) {
            TextField("Enter room Id", text: $roomId)
            Button("join") {
                guard !roomId.isEmpty else { return }
                landingViewModel.joinGame(to: roomId)
            }
        }
        .onReceive(landingViewModel.$roomId) { roomId in
            guard roomId != nil else { return }
            self.shouldShowGrid = true
        }
        .animation(.default, value: shouldShowGrid)
    }
}
