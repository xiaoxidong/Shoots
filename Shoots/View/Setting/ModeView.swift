//
//  ModeView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct ModeView: View {
    @AppStorage("colorMode") private var colorMode: ShootColorScheme = .none
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Text("选择主题模式")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.shootBlack)
            
            Button(action: {
                colorMode = .none
            }) {
                HStack {
                    Text("🌓").bold().font(.system(size: 30))
                    Text("跟随系统")
                        .bold()
                        .foregroundColor(Color.shootBlack)
                    Spacer()
                    if colorMode == .none {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.shootRed)
                    }
                }.contentShape(Rectangle())
            }.buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            Divider()
            
            Button(action: {
                colorMode = .light
            }) {
                HStack {
                    Text("🌕").bold().font(.system(size: 30))
                    Text("浅色模式")
                        .bold()
                        .foregroundColor(Color.shootGray)
                    Spacer()
                    if colorMode == .light {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.shootRed)
                    }
                }.contentShape(Rectangle())
                
            }.buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            
            Divider()
            
            Button(action: {
                colorMode = .dark
            }) {
                HStack {
                    Text("🌑").bold().font(.system(size: 30))
                    Text("深色模式")
                        .bold()
                        .foregroundColor(Color.shootGray)
                    Spacer()
                    if colorMode == .dark {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.shootRed)
                    }
                }.contentShape(Rectangle())
            }.buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
        }
        .padding(.top, 26)
        .frame(maxWidth: 560)
        .background(Color.white)
        .clipShape(RoundedCornersShape(tl: 36, tr: 36))
    }
}

struct ModeView_Previews: PreviewProvider {
    static var previews: some View {
        ModeView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        ModeView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
