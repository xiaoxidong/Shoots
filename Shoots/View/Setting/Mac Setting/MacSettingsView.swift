//
//  MacSettingsView.swift
//  Shoots_Mac
//
//  Created by XiaoDong Yuan on 2023/3/30.
//

import SwiftUI
import LaunchAtLogin

struct MacSettingsView: View {
    @State var selection = 1
    var body: some View {
        TabView(selection: $selection) {
            basicView
                .tabItem {
                    Label("  基础设置  ", systemImage: "gearshape.fill")
                }
                .tag(0)
            ShootsAIView()
                .tabItem {
                    Label("  Shoots AI  ", systemImage: "theatermask.and.paintbrush.fill")
                }
                .tag(1)
            UberaboutView(bundle: Bundle.main)
                .tabItem {
                    Label("  关于我们  ", systemImage: "app.badge.fill")
                }
                .tag(2)
        }.frame(width: 520, height: 520)
    }
    
    @AppStorage("colorMode") private var colorMode: ShootColorScheme = .none
    @AppStorage("statusIcon") var statusIcon: String = "photo.fill.on.rectangle.fill"
    @Environment(\.colorScheme) var colorScheme
    @State var showPro = false
    @EnvironmentObject var user: UserViewModel
    @State var logout = false
    var basicView: some View {
        ScrollView(showsIndicators: false) {
            Form {
                Section {
                    LabeledContent("支持开发者：") {
                        Button {
                            showPro.toggle()
                        } label: {
                            HStack {
                                Image("pro")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                Text("买杯饮料")
                            }
                        }
                    }.padding(.vertical, 6)
                        .padding(.top, 36)
                    
                    LabeledContent("外观设置：") {
                        Menu {
                            Button(action: {
                                colorMode = .none
                            }) {
                                Text("🌓 跟随系统")
                            }
                            
                            Button(action: {
                                colorMode = .light
                            }) {
                                Text("🌕 浅色模式")
                            }
                            
                            Button(action: {
                                colorMode = .dark
                            }) {
                                Text("🌑 深色模式")
                            }
                        } label: {
                            if colorMode == .none {
                                Text("🌓 跟随系统")
                            } else if colorMode == .light {
                                Text("🌕 浅色模式")
                            } else if colorMode == .dark {
                                Text("🌑 深色模式")
                            }
                        }.frame(width: 120)
                    }.padding(.vertical, 6)
                    
                    LabeledContent("状态栏图标：") {
                        Menu {
                            Button(action: {
                                statusIcon = "theatermask.and.paintbrush.fill"
                            }) {
                                Image(systemName: "theatermask.and.paintbrush.fill")
                            }
                            
                            Button(action: {
                                statusIcon = "photo.fill.on.rectangle.fill"
                            }) {
                                Image(systemName: "photo.fill.on.rectangle.fill")
                            }
                            
                            Button(action: {
                                statusIcon = "photo.stack.fill"
                            }) {
                                Image(systemName: "photo.stack.fill")
                            }
                        } label: {
                            Label("图标", systemImage: statusIcon)
                        }.frame(width: 120)
                    }.padding(.vertical, 6)
                }
                LabeledContent {
                    Rectangle()
                        .frame(width: 200, height: 1)
                        .opacity(0.1)
                } label: {
                    Rectangle()
                        .frame(width: 200, height: 1)
                        .opacity(0.1)
                }

                Section {
                    LabeledContent("分享应用：") {
                        ShareLink(items: [URL(string: "https://apps.apple.com/cn/app/id1140397642")!]) {
                            HStack {
                                Image("share")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                Text("分享给好友")
                            }
                        }
                    }.padding(.vertical, 6)
                        .padding(.top)
                    
                    LabeledContent("评价应用：") {
                        Button {
                            let urlString = "itms-apps://itunes.apple.com/app/id1140397642?action=write-review"
                            let url = URL(string: urlString)
                            NSWorkspace.shared.open(url!)
                        } label: {
                            HStack {
                                Image("rate")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                Text("五星好评")
                            }
                        }
                    }.padding(.vertical, 6)
                    LabeledContent("反馈问题：") {
                        VStack(alignment: .leading) {
                            Button {
                                let service = NSSharingService(named: NSSharingService.Name.composeEmail)
                                service?.recipients = ["834599524@qq.com"]
                                service?.subject = "使用意见反馈"
                                service?.perform(withItems: [""])
                            } label: {
                                HStack {
                                    Image("feedback")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 14, height: 14)
                                    Text("邮件反馈")
                                }
                            }
                            
                            Text("微信小助手：")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.shootGray)
                            + Text("Poke202020")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.shootGray)
                        }
                    }.padding(.vertical, 6)
                    
                    LabeledContent("社交媒体：") {
                        Button {
                            let urlStr = "https://weibo.com/u/5682979153"
                            let url = URL(string: urlStr)
                            NSWorkspace.shared.open(url!)
                        } label: {
                            HStack {
                                Image("weibo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                Text("新浪微博")
                            }
                        }
                    }.padding(.vertical, 6)
                }
                
                LabeledContent {
                    Rectangle()
                        .frame(width: 200, height: 1)
                        .opacity(0.1)
                } label: {
                    Rectangle()
                        .frame(width: 200, height: 1)
                        .opacity(0.1)
                }
                Section {
                    LabeledContent("开机启动：") {
                        // 不知道为什么，添加了登录自动开启之后，iOS 的预览就不能使用，所以这里暂时注销了，可以添加下面的 SPM，然后引入库即可。
                        //https://github.com/sindresorhus/LaunchAtLogin
                        LaunchAtLogin.Toggle {
                            Text("开启")
                        }
                    }.padding(.vertical, 6)
                        .padding(.top)
                    LabeledContent("退出：") {
                        Button {
                            NSApp.terminate(self)
                        } label: {
                            Text("关闭 Shoots")
                        }
                    }.padding(.vertical, 6)
                    
                    if user.login {
                        LabeledContent("已登录：") {
                            Button {
                                withAnimation(.spring()) {
                                    logout = true
                                }
                            } label: {
                                Text("退出登录")
                            }
                        }.padding(.vertical, 6)
                            .alert("确认退出？", isPresented: $logout) {
                                Button("取消", role: .cancel) { }
                                Button("退出") {
                                    Task {
                                        await user.logout()
                                    }
                                }
                            }
                    }
                }
            }
            
            SettingRateView()
                .padding(.top)
                .frame(width: 460)
            
            Text("🎈A YUANXIAODONG PRODUCT MADE WITH ♥️")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color.gray)
                .padding(.top, 86)
                .padding(.bottom, 26)
        }.sheet(isPresented: $showPro) {
            ProView()
                .sheetFrameForMac()
        }
    }
}

struct MacSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MacSettingsView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        MacSettingsView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
