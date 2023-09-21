//
//  GradientModifier.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/21.
//

import SwiftUI

struct GradientModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            content
                .background(color.gradient)
        } else {
            content
                .background(color)
        }
    }
}
