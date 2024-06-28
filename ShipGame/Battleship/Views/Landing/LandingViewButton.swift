//
//  LandingViewButton.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-28.
//

import SwiftUI

struct LandingViewButton: View {
    @EnvironmentObject private var viewModel: BattleshipViewModel
    @Binding var shouldShowRoomIdAlert: Bool
    let buttonType: LandingViewButtonType
    let connectionState: ConnectionState
    
    var body: some View {
        Button {
            switch buttonType {
            case .create:
                viewModel.connect(from: .host)
            case .join:
                shouldShowRoomIdAlert = true
            }
        } label: {
            ZStack {
                if connectionState.inProgress {
                    ProgressView()
                } else {
                    Text(buttonType.title)
                        .padding(8)
                }
            }
            .frame(width: buttonType.width, height: buttonType.height)
        }
        .disabled(connectionState.inProgress)
        .buttonStyle(.borderedProminent)
        .fontWeight(.semibold)
    }
}
