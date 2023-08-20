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
    @EnvironmentObject var user: UserViewModel
    @StateObject var delete = DeleteViewModel()
    @State var showDelete = false
    var body: some View {
        ZStack {
            Color.shootWhite.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("隐私协议")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color.shootBlack)
                    Spacer()
                    #if os(iOS)
                        closeButton
                    #else
                        MacCloseButton()
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
                            Text("1. 数据使用范围").font(.headline)
                            Text("所有数据仅供用户自己查看，应用不会分享用户产品数据给第三方。")

                            Spacer().frame(height: 10)
                            Text("2. 信息披露").font(.headline)
                            Text("a. 本软件不会将您的信息披露给不受信任的第三方。")
                            Text("b. 根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露。")
                        }
                        Group {
                            Spacer().frame(height: 10)
                            Text("3. 信息存储").font(.headline)
                            Text("本软件收集的有关您的信息和资料将保存在您的设备本地。")
                            Spacer().frame(height: 10)
                            Text("4. 使用条款的变更").font(.headline)
                            Text("当有新的使用条款跟新的时候，我们会在这个页面更新内容，已经之前版本的条款，您可以查看，这些条款更新之后就会立即生效。")
                        }
                        Group {
                            Spacer().frame(height: 10)
                            Text("5. 联系我们").font(.headline)
                            Text("如果您对我们的隐私政策有任何疑问或建议，请随时通过设置页的联系我们与我们联系。")
                            if user.login {
                                Spacer().frame(height: 10)
                                Text("6. 删除账号").font(.headline)
                                Text("如果你希望不在保留您在 Shoots 的账号，可以在这里进入删除账号，注意删除之后将无法恢复。")
                                Button("删除账号") {
                                    withAnimation(.spring()) {
                                        showDelete.toggle()
                                    }
                                }.foregroundColor(.blue)
                                    .alert(isPresented: $showDelete) {
                                        Alert(title: Text("确认删除？"), message: Text("删除之后将无法恢复，确认删除？"), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.destructive(Text("删除"), action: {
                                            Task {
                                                await delete.delete(token: user.token) { success in
                                                    if success {
                                                        user.login = false
                                                        user.token = ""
                                                        APIService.token = ""
                                                        Task {
                                                            await user.logout()
                                                        }
                                                    }
                                                }
                                            }
                                        }))
                                    }
                            }
                        }

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
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))

        PrivacyView(showPrivacy: .constant(true))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
