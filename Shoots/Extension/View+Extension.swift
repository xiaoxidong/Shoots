//
//  View+Extension.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    func resignFirstResponder() {
        #if os(iOS)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
    
    public func shadow(
        color: Color = .black,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat
    ) -> some View {
        shadow(color: color, radius: blur / 2, x: x, y: y)
    }
    
    
    func sheetFrameForMac() -> some View {
        #if os(iOS)
        self
        #else
        self.frame(minWidth: 400, idealWidth: 600, maxWidth: 700, minHeight: 500, idealHeight: 800, maxHeight: 900)
        #endif
    }
}
