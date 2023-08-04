//
//  CheckToggleStyle.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/2.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation(.spring()) {
                configuration.isOn.toggle()
            }
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }.foregroundStyle(Color.accentColor)
            .buttonStyle(.plain)
    }
}
