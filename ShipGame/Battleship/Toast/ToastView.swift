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
                .padding(.leading)
                .foregroundColor(toast.style.color.opacity(0.7))
            Text(toast.title)
                .font(.headline)
                .fontWeight(.medium)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? .black.opacity(0.8) : .white)
                .blur(radius: 16)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(toast.style.color.opacity(0.05))
                        .shadow(color: toast.style.color, radius: 8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(toast.style.color.opacity(0.5), lineWidth: 1)
                        }
                }
        )
    }
}
