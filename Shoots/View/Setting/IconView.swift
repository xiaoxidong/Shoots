//
//  IconView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct IconView: View {
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 260), spacing: 12),
        GridItem(.flexible(minimum: 100, maximum: 260), spacing: 12),
        GridItem(.flexible(minimum: 100, maximum: 260), spacing: 12),
    ]
    var body: some View {
        VStack(spacing: 16) {
            Text("选择图标")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)

            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(1 ... 6, id: \.self) { _ in
                    Image("Instagram")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 106, height: 106)
                        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                }
            }

        }.frame(maxWidth: .infinity)
            .padding()
            .background(Color.shootWhite)
            .frame(maxWidth: 560)
            .clipShape(RoundedCornersShape(tl: 36, tr: 36))
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))

        IconView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
