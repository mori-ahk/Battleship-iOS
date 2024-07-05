//
//  RematchView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-07-04.
//

import SwiftUI

struct RematchView: View {
    var status: RematchStatus
    var onAccept: () -> Void
    var onReject: () -> Void
    
    var body: some View {
        VStack {
            switch status {
            case .requested:
                requestedView
            case .accepted:
                Text("starting a new game")
            case .rejected:
                Text("rematch rejected, redirecting to home page")
            }
        }
    }
    
    @ViewBuilder
    private var requestedView: some View {
        Text("Rematch request")
            .font(.title)
            .fontWeight(.heavy)
        
        Text("Your opponent has requested a rematch. Would you like to play again?")
            .font(.title3)
            .fontWeight(.semibold)
        HStack {
            Button {
                onAccept()
            } label: {
                Text("Sure!")
                    .padding(8)
            }
            
            Button {
                onReject()
            } label: {
                Text("No")
                    .padding(8)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}
