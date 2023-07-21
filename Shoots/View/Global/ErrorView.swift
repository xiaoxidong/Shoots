//
//  ErrorView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/7/20.
//

import SwiftUI

struct ErrorView: View {
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image("error")
            Text("出现错误，请重试")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.shootGray)
                .padding(.leading, 12)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView {}
    }
}
