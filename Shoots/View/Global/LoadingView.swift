//
//  LoadingView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/7/20.
//

import SwiftUI

struct LoadingView: View {
    var text: String = "努力加载中..."
    var body: some View {
        VStack(spacing: 12) {
            #if os(iOS)
                DNALoading(numberOfBalls: 4, ballSize: 12)
            #else
                ArcsIndicatorView()
                    .frame(width: 36, height: 36)
            #endif

            Text(LocalizedStringKey(text))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.shootGray)
                .padding(.leading, 12)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
