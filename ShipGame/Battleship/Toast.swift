//
//  Toast.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-26.
//

struct Toast {
    typealias Action = () -> Void
    let title: String
    let style: ToastStyle
    let duration: Double = 2
    let onDismiss: Action?
}

extension Toast: Equatable {
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.title == rhs.title
    }
}
