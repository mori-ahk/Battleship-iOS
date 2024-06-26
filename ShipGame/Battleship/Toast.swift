//
//  Toast.swift
//  Battleship
//
//  Created by Mori Ahmadi on 2024-06-26.
//

struct Toast {
    let action: ToastAction
    let style: ToastStyle
    let duration: Double = 2
}

extension Toast: Equatable {
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.action == rhs.action
    }
}
