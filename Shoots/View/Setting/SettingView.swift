//
//  SettingView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
#if os(iOS)
import MessageUI
#endif

struct SettingView: View {
    @State var showPro = false
    @State var showPrivacy = false
    @State var showAgreement = false
    @State var openWeibToast = false
    @State var showToast = false
    @State var showMail = false
    @State var showShare = false
    @State var showModeSetting = false
    @State var showIconSetting = false
    #if os(iOS)
    @State var result: Result<MFMailComposeResult, Error>? = nil
    #endif
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Group {
                    Divider()
                    SettingCellView(image: "pro", text: "Shoots Pro") {
                        showPro.toggle()
                    }
                    
                    // 基础设置
                    Text("基础设置")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.top, 36)
                    SettingCellView(image: "mode", text: "外观设置") {
                        showModeSetting.toggle()
                    }
                    SettingCellView(image: "appicon", text: "应用图标") {
                        showIconSetting.toggle()
                    }
                }
                
                Group {
                    Text("支持我们")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.top, 36)
                    SettingCellView(image: "shareapp", text: "分享给好友") {
                        showShare.toggle()
                    }
                    #if os(iOS)
                    .sheet(isPresented: self.$showShare, onDismiss: {
                        print("Dismiss")
                    }, content: {
                        ActivityViewController(activityItems: [URL(string: "https://apps.apple.com/cn/app/id1610715711")!])
                    })
                    #endif
                    SettingCellView(image: "rate", text: "给我们一个五星评价") {
                        let urlString = "itms-apps://itunes.apple.com/app/id1140397642?action=write-review"
                        let url = URL(string: urlString)
                        #if os(iOS)
                        UIApplication.shared.open(url!)
                        #else
                        NSWorkspace.shared.open(url!)
                        #endif
                    }
                    SettingCellView(image: "feedback", text: "问题反馈") {
                        #if os(iOS)
                        if MFMailComposeViewController.canSendMail() {
                            self.showMail = true
                        } else {
                            showToast = true
                        }
                        #else
                        
                        #endif
                    }
                    #if os(iOS)
                    .sheet(isPresented: self.$showMail) {
                        MailView(result: self.$result)
                    }
                    #endif
                    SettingCellView(image: "weibo", text: "新浪微博") {
                        let urlStr = "sinaweibo://userinfo?uid=5682979153"
                        let url = URL(string: urlStr)
                        #if os(iOS)
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!)
                        } else {
                            //提示没有安装 BasicGrammar app
                            openWeibToast = true
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        }
                        #else
                        NSWorkspace.shared.open(url!)
                        #endif
                    }
                    
                    
                    Text("隐私协议")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.top, 36)
                    SettingCellView(image: "yinsi", text: "用户隐私") {
                        showPrivacy.toggle()
                    }.sheet(isPresented: self.$showPrivacy) {
                        PrivacyView(showPrivacy: self.$showPrivacy)
                    }
                    SettingCellView(image: "xieyi", text: "使用协议") {
                        showAgreement.toggle()
                    }.sheet(isPresented: self.$showAgreement) {
                        AgreementView(showAgreement: $showAgreement)
                    }
                }
                
                SettingRateView()
                    .padding(.top)
                
                Text("🎈A YUANXIAODONG PRODUCT MADE WITH ♥️")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.gray)
                    .padding(.top, 86)
                    .padding(.bottom, 26)
            }
        }
        .navigationTitle("设置")
        .navigationBarBackButtonHidden()
        #if os(iOS)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .tint(.shootBlue)
                }
            }
        }
        #endif
        .sheet(isPresented: $showPro) {
            #if os(iOS)
            ProView()
            #endif
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .systemImage("drop.triangle.fill", .red), title: "您的手机暂时无法发送邮件，可通过联系我们联系！")
        }
        .bottomSlideOverCard(isPresented: $showModeSetting) {
            ModeView()
        }
        .bottomSlideOverCard(isPresented: $showIconSetting) {
            IconView()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
        }
    }
}
