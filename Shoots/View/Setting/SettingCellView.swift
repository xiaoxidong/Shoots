//
//  SettingCellView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/22.
//

import SwiftUI

struct SettingCellView: View {
    var image: String
    var text: String
    let action: () -> Void
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    var padding: CGFloat {
        #if os(iOS)
        if horizontalSizeClass == .regular && verticalSizeClass == .compact {
            return 56
        } else {
            return 16
        }
        #else
        return 16
        #endif
    }
    var body: some View {
        VStack(spacing: 0) {
            Button {
                action()
            } label: {
                HStack {
                    Image(image)
                        .frame(width: 24, height: 24)
                    Text(LocalizedStringKey(text))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.shootBlack)
                    Spacer()
                }.frame(height: 56)
                .contentShape(Rectangle())
                
            }.buttonStyle(PlainButtonStyle())

            Divider()
        }.padding(.horizontal, padding)
    }
}

struct SettingCellView_Previews: PreviewProvider {
    static var previews: some View {
        SettingCellView(image: "pro", text: "支持开发者") {
            
        }
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh"))
        
        SettingCellView(image: "pro", text: "支持开发者") {
            
        }
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
