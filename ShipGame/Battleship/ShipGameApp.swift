//
//  ShipGameApp.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-03-18.
//

import SwiftUI

@main
struct ShipGameApp: App {
    @StateObject private var viewModel = BattleshipViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(viewModel)
                .fontDesign(.monospaced)
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                Task {
                    if await viewModel.ping() == false {
                        if let currentSession = viewModel.session {
                            viewModel.connect(
                                from: viewModel.connectionSource,
                                to: currentSession.id
                            )
                        }
                    }
                }
            }
        }
    }
}
