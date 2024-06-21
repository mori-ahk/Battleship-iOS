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
    
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(viewModel)
                .fontDesign(.monospaced)
        }
    }
}
