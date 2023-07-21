//
//  MacCloseButton.swift
//  Shoots_Mac
//
//  Created by XiaoDong Yuan on 2023/3/27.
//

import SwiftUI

struct MacCloseButton: View {
    @Environment(\.dismiss) var dismiss

    @State var hover = false
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .semibold))
                .padding(8)
                .background(Color.shootBlue.opacity(hover ? 0.2 : 0))
                .clipShape(Circle())
                .shadow(radius: hover ? 12 : 0)
        }.buttonStyle(.plain)
            .onHover { hover in
                withAnimation(.spring()) {
                    self.hover = hover
                }
            }
    }
}

struct MacCloseButton_Previews: PreviewProvider {
    static var previews: some View {
        MacCloseButton()
    }
}
