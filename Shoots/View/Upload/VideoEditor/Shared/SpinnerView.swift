//
//  SpinnerView.swift
//  Items
//
//  Created by Ian on 27/03/2022.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct SpinnerView: View {
    public var body: some View {
        if #available(iOS 14.0, macOS 11, *) {
            ProgressView()
                .progressViewStyle(.circular)
#if os(macOS)
                .scaleEffect(0.5)
#endif
        } else {
            Text("...")
            // Fallback on earlier versions
        }
    }
}
