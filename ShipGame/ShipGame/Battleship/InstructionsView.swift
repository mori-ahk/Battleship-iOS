//
//  InstructionsView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import SwiftUI

struct InstructionsView: View {
    @State private var shouldShowInstructions: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                shouldShowInstructions.toggle()
            } label: {
                Text("Show Instructions")
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            if shouldShowInstructions {
                ForEach(Array(Instruction.all.enumerated()), id: \.offset) { (index, element) in
                    Text("\(index). \(element.description)")
                }
            }
        }
        .animation(.default, value: shouldShowInstructions)
    }
}
