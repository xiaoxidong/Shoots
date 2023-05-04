//
//  SettingRateView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct SettingRateView: View {
    var body: some View {
        Button {
            let urlString = "itms-apps://itunes.apple.com/app/id1610715711?action=write-review"
            let url = URL(string: urlString)
            
            #if os(iOS)
            UIApplication.shared.open(url!)
            #else
            NSWorkspace.shared.open(url!)
            #endif
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("评价应用")
                        .bold()
                    
                    Text("如果应用对你有帮助，请帮我们在应用商店写个好评，对我们非常有帮助。")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.shootLight)
                        .lineSpacing(4)
                    
                    Image("srate")
                        .offset(x: -4)
                }
                Image("app")
            }.frame(maxWidth: 560)
                .padding(.top, 12)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.shootBlue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal)
        }.buttonStyle(PlainButtonStyle())
    }
}


struct SettingRateView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRateView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        SettingRateView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
