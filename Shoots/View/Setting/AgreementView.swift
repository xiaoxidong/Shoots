//
//  AgreementView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/22.
//

import SwiftUI

struct AgreementView: View {
    @Binding var showAgreement: Bool

    var body: some View {
        ZStack {
            Color("bg").edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("使用条款")
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

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Group {
                            Text("在购买 Pro 之前，你可以阅读 App 的使用协议来确定更多的信息。")
                            Text("App 功能").bold().font(.headline)
                            Text("Shoots 是一款截图管理 应用，可以在 iPhone, iPad 和 Mac 多端同步使用。")

                            Spacer().frame(height: 10)
                        }
                        Group {
                            Text("免费版本").bold().font(.headline)
                            Text("Shoots 预览提供免费的 10 天全部功能免费试用，免费试用结束之后您可以选择付费继续使用 Shoots。")

                            Spacer().frame(height: 10)
                            Text("订阅").bold().font(.headline)
                            Text("10 天试用期结束之后您可以选择订阅继续使用，具体订阅可以参考付费页面。")
                        }

                        Group {
                            Spacer().frame(height: 10)
                            Text("退款").bold().font(.headline)
                            Text("如果您在使用 Shoots Pro 的过程中有任何的问题，都可以通过底部的邮件联系我们获得帮助，但是如果您依然觉得无法达到您的要求，可以选择退款，但是退款不是有开发者来操作的，您可以联系 Apple 的支持团队来处理退款。")

                            Spacer().frame(height: 10)
                            Text("使用条款的变更").bold().font(.headline)
                            Text("当有新的使用条款跟新的时候，我们会在这个页面更新内容，已经之前版本的条款，您可以查看，这些条款更新之后就会立即生效。")

                            Spacer().frame(height: 10)
                            Text("联系我们").bold().font(.headline)
                            Text("如果您对我们的使用条款有任何疑问或建议，请随时通过设置页的联系我们与我们联系。")
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

struct AgreementView_Previews: PreviewProvider {
    static var previews: some View {
        AgreementView(showAgreement: .constant(true))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))

        AgreementView(showAgreement: .constant(true))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
