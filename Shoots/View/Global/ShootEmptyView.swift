//
//  ShootEmptyView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/22.
//

import SwiftUI

struct ShootEmptyView: View {
    var text: String = "这里什么都没有呢"
    
    var body: some View {
        VStack(spacing: 16) {
            Image("empty")
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.shootGray)
        }
    }
}

struct ShootEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ShootEmptyView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh"))
        
        ShootEmptyView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
