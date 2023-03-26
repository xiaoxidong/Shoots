//
//  ShootBlurView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct ShootBlurView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ScrollView {
                Divider()
                Image("s1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 560)
            }
            .navigationTitle("敏感信息隐藏")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 保存截图
                        
                        dismiss()
                    } label: {
                        Text("保存")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }
                }
            }
        }
    }
}

struct ShootBlurView_Previews: PreviewProvider {
    static var previews: some View {
        ShootBlurView()
    }
}
