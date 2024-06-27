//
//  ToastView.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-26.
//

import SwiftUI

struct ToastView: View {
    @Environment(\.colorScheme) private var colorScheme
    let toast: Toast

    var body: some View {
        HStack {
            Image(systemName: toast.style.icon)
                .font(.title2)
                .fontWeight(.medium)
                .padding()
                .foregroundStyle(toast.style.color)
            Text(toast.action.title)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(toast.style.color.opacity(0.1))
                .stroke(toast.style.color, lineWidth: 1)
        )
    }
}
