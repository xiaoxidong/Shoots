//
//  PrivacyView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/22.
//

import SwiftUI

struct PrivacyView: View {
    @Binding var showPrivacy: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Color("bg").edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("隐私协议")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color.shootBlack)
                    Spacer()
                    #if os(iOS)
                    closeButton
                    #endif
                }
                .padding(.horizontal)
                .padding(.bottom, 6)
                .padding(.top, 36)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        Group {
                            Text("Shoots 尊重并保护所有使用服务用户的个人隐私和数据隐私。除本隐私权政策另有规定外，在未征得您事先许可的情况下，本软件不会将这些信息对外披露或向第三方提供。本软件会不时更新本隐私权政策。您在同意本软件服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本软件服务使用协议不可分割的一部分。")
                            Spacer().frame(height: 10)
                            Text("1.数据使用范围").bold().font(.headline)
                            Text("所有数据仅供用户自己及用户共享的用户查看，应用不会分享用户产品数据给第三方。")
                            
                            Spacer().frame(height: 10)
                            Text("2.信息披露").bold().font(.headline)
                            Text("a)本软件不会将您的信息披露给不受信任的第三方。")
                            Text("b)根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露。")
                        }
                        Spacer().frame(height: 10)
                        Text("3.信息存储").bold().font(.headline)
                        Text("本软件收集的有关您的信息和资料将保存在您的设备本地。")
                        Spacer().frame(height: 10)
                        Text("4.使用条款的变更").bold().font(.headline)
                        Text("当有新的使用条款跟新的时候，我们会在这个页面更新内容，已经之前版本的条款，您可以查看，这些条款更新之后就会立即生效。")
                        Spacer().frame(height: 10)
                        Text("5.联系我们").bold().font(.headline)
                        Text("如果您对我们的隐私政策有任何疑问或建议，请随时通过设置页的联系我们与我们联系。")
                        
                        
                    }.padding()
                    .font(.subheadline)
                    .foregroundColor(Color.shootBlack)
                    .lineSpacing(6)
                    
                }
                Spacer()
            }
        }
    }
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.dismiss) var dismiss
    var closeButton: some View {
        Group {
            if horizontalSizeClass == .regular && verticalSizeClass == .compact {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color.shootRed)
                }.padding(.bottom, 12)
            }
        }
    }
    #endif
}


struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView(showPrivacy: .constant(true))
    }
}