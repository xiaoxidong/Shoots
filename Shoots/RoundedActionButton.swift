//
//  RoundedActionButton.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/15.
//

import SwiftUI

struct RoundedActionButton: View {
    var body: some View {
        Capsule()
            .frame(height: 46)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color("shootRed"))
            .padding(.horizontal, 16)
            .onTapGesture {
                // 处理点击事件
            }
    }
}

struct RoundedActionButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedActionButton()
    }
}
