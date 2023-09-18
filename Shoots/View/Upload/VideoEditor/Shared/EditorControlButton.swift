//
//  SwiftUIView.swift
//  
//
//  Created by Ian on 30/12/2022.
//

import SwiftUI

@available(iOS 14.0, macOS 11, *)
struct EditorControlButton: View {
    var imageString: String
    var action: () -> Void

    init(_ imageString: String, action: @escaping () -> Void) {
        self.imageString = imageString
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: imageString)
                .font(.title)
                .padding(6)
                .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .foregroundColor(.white)
    }
}
