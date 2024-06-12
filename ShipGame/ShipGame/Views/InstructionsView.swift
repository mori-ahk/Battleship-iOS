//
//  InstructionsView.swift
//  ShipGame
//
//  Created by Mori Ahmadi on 2024-05-31.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Array(Instruction.all.enumerated()), id: \.offset) { (index, element) in
                Text("\(index + 1). \(element.description)")
                    .font(.subheadline)
                    .padding()
                if element != Instruction.all.last! {
                    Divider()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.prussianBlue.opacity(0.1))
        )
    }
}
