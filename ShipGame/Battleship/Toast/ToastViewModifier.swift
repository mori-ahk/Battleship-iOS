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
        ZStack {
            content
            if toast != nil {
                mainToastView()
            }
        }
        .onChange(of: toast) { (_, _) in
            showToast()
        }
        .animation(.default, value: toast)
    }

    @ViewBuilder func mainToastView() -> some View {
        if let toast {
            VStack {
                ToastView(toast: toast)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .transition(.blurReplace)
            .padding(.horizontal, 48)
        }
    }

    private func showToast() {
        guard let toast = toast else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        if toast.duration > 0 {
            let task = DispatchWorkItem { dismissToast() }

            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }

    private func dismissToast() {
        toast = nil
    }
}
