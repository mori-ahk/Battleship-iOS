//
//  LandingView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-04-21.
//

import SwiftUI

struct LandingView: View {
    @State private var shouldShowGrid: Bool = false
    
    var body: some View {
        ZStack {
            if !shouldShowGrid {
                VStack {
                    Button {
                        
                    } label: {
                        Text("Create")
                    }
                    Button {
                        
                    } label: {
                        Text("Join")
                    }
                }
            } else {
                
            }
        }
    }
}
