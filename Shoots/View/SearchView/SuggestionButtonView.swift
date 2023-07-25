//
//  SuggestionButtonView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/7/25.
//

import SwiftUI

struct SuggestionButtonView: View {
    var image: String
    var name: String
    let action: () -> Void

    @State var hover = false
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                    .font(.system(size: 22, weight: .bold))
                Text(name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.shootBlack)
                Spacer()
                Image(systemName: "chevron.right")
                    .bold()
                    .foregroundColor(.shootGray)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(hover ? Color.shootBlue.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .contentShape(Rectangle())
        }.buttonStyle(.plain)
            .onHover { hover in
                withAnimation(.spring()) {
                    self.hover = hover
                }
            }
    }
}

struct SuggestionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionButtonView(image: "app.badge.fill", name: "Instagram") {}
    }
}
