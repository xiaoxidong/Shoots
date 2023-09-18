//
//  File.swift
//  
//
//  Created by Ian on 08/12/2022.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
extension View {
    @inlinable
    public func overlay<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        self.overlay(content())
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension View {
    func readViewSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

@available(iOS 13.0, macOS 10.15, *)
private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
