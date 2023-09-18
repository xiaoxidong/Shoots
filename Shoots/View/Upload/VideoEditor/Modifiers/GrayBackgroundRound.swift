//
//  GrayBackgroundRound.swift
//  
//
//  Created by Ian on 04/12/2022.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
extension View {
    func grayBackgroundRound() -> some View {
        modifier(GrayBackgroundRound())
    }
}

@available(iOS 13.0, macOS 10.15, *)
struct GrayBackgroundRound: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .background(Color.black.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension View {
    func grayBackgroundCircle() -> some View {
        modifier(GrayBackgroundCircle())
    }
}

@available(iOS 13.0, macOS 10.15, *)
struct GrayBackgroundCircle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .background(Color.black.opacity(0.5))
            .clipShape(Circle())
    }
}
