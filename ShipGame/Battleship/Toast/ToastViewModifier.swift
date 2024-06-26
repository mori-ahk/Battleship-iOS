//
//  ToastViewModifier.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-26.
//

import SwiftUI

struct ToastViewModifier: ViewModifier {
    @Binding var toast: Toast?

    func body(content: Content) -> some View {
        content
            .overlay(
                mainToastView()
                    .offset(y: -30)
                    .animation(
                        .bouncy(duration: 0.75, extraBounce: 0.05),
                        value: toast
                    )
            )
        .onChange(of: toast) { (_, _) in
            showToast()
        }
    }

    @ViewBuilder func mainToastView() -> some View {
        if let toast {
            VStack {
                Spacer()
                ToastView(toast: toast)
            }
            .transition(.move(edge: .bottom))
            .padding(.horizontal, 48)
        }
    }

    private func showToast() {
        guard let toast = toast else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        if toast.duration > 0 {

            let task = DispatchWorkItem {
                dismissToast()
                if let onDismiss = toast.onDismiss {
                    onDismiss()
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }

    private func dismissToast() {
        withAnimation { toast = nil }
    }
}
