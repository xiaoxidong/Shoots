//
//  UberaboutWindowButtonStyle.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/3.
//

import SwiftUI

struct UberaboutWindowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let color = Color.accentColor
        let pressed = configuration.isPressed
        return configuration.label
            .font(Font.body.weight(.medium))
            .padding([.leading, .trailing], 8.0)
            .padding([.top], 4.0)
            .padding([.bottom], 5.0)
            .background(color.opacity(pressed ? 0.08 : 0.14))
            .foregroundColor(color.opacity(pressed ? 0.8 : 1.0))
            .cornerRadius(5.0)
    }
}
