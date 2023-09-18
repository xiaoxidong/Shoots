//
//  OnTapModifier.swift
//  Items
//
//  Created by Ian on 24/06/2022.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
struct OnTap: ViewModifier {
    let response: (CGPoint) -> Void

    @State private var location: CGPoint = .zero
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                response(location)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { location = $0.location }
            )
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension View {
    func onTapGesture(_ handler: @escaping (CGPoint) -> Void) -> some View {
        modifier(OnTap(response: handler))
    }
}
