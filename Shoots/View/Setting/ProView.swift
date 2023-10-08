//
//  ProView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/22.
//

import SwiftUI
import StoreKit
#if os(iOS)
import MessageUI
#endif

struct ProView: View {
    @Environment(\.dismiss) var dismiss

    @State var showPrivacy = false
    @State var showMail = false
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var result: Result<MFMailComposeResult, Error>? = nil
    var iPhonelandscape: Bool {
        if horizontalSizeClass == .regular && verticalSizeClass == .compact {
            return true
        } else {
            return false
        }
    }
    @State var selectedTab: Int = 0
    #endif

    @State var showBuyLoadingIndicator = false
    @State var showYearLoadingIndicator = false
    @State var selected: Support = .year
    
    @State var monthMoney = "¥12.00"
    @State var yearMoneyString = ""
    @State var yearMoney = "¥98.00"
    @State var lifeMoney = "¥348.00"
    @State var lifeHalfMoney = "¥198.00"

    @State var counter: Int = 0
   
    @State var showToast = false
    @State var toastText = ""
    @State var timer: Timer? = nil
    
    enum Protext: String {
        case content
        case number
        case copy
        case userflow
        case ai
        
        var title: String {
            switch self {
            case .content:
                return "无限制浏览付费内容"
            case .number:
                return "无限制管理截图数量"
            case .copy:
                return "复制粘贴原型组件"
            case .userflow:
                return "查看用户流程图片组"
            case .ai:
                return "使用 AI 进行原型设计"
            }
        }
        var subtitle: String {
            switch self {
            case .content:
                return "无限制查看付费内容，应用更新了什么，Gif 交互，设计小细节"
            case .number:
                return "普通用户最多可以上传 1000 张截图"
            case .copy:
                return "直接复制粘贴设计内容到各个设计工具，不仅仅是截图"
            case .userflow:
                return "一个流程里的操作按照顺序查看，了解更彻底"
            case .ai:
                return "描述你的需求，自动生成可交互的高保真原型"
            }
        }
        
        var indicator: String {
            switch self {
            case .content:
                return "免费用户每天 5 次查看"
            case .number:
                return "普通用户够用"
            case .copy:
                return "即将上线"
            case .userflow:
                return "知道从哪到哪"
            case .ai:
                return "即将即将上线"
            }
        }
    }
    var titles: [Protext] = [.content, .number, .copy, .userflow, .ai]
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                content
                #if os(iOS)
                iOSTitleView
                #endif
                priceView
                Button {
                    showBuyLoadingIndicator = true
                    restore()
                } label: {
                    HStack {
                        Text("已经购买？")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.shootBlack)
                            + Text("恢复购买")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.shootRed)
                    }
                    .padding(.vertical, 16)
                    .contentShape(Rectangle())
                }.buttonStyle(PlainButtonStyle())
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        Text("\(Image(systemName: "bell.circle.fill"))")
                            .foregroundColor(Color.shootRed)
                            + Text(" 按年付费确认订阅之后将会向您的 App Store 账户收取费用，按照年的时间长度收取您的费用。订阅服务将会在当前周期结束时自动续订并收取下一年的费用。")
                            .foregroundColor(Color.shootBlack)
                    }.font(.system(size: 14))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)

                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    Group {
                        Text("\(Image(systemName: "bell.circle.fill"))")
                            .foregroundColor(Color.shootRed)
                            + Text(" 取消自动续订需要在当前订阅周期结束前 24 小时完成，可以在下面的 App Store 订阅管理里查看，如果有任何问题，请联系我们。")
                            .foregroundColor(Color.shootBlack)
                    }.font(.system(size: 14))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)

                    VStack(spacing: 16) {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showPrivacy = true
                            }) {
                                Text("隐私条款")
                                    .bold()
                                    .foregroundColor(Color.shootRed)
                                    .fixedSize()
                            }.buttonStyle(.plain)
                                .sheet(isPresented: self.$showPrivacy) {
                                    PrivacyView(showPrivacy: self.$showPrivacy)
                                }

                            Spacer()
                            Text("·")
                                .bold()
                                .foregroundColor(Color.shootRed)
                                .fixedSize()
                            Spacer()

                            Button(action: {
                                let url = URL(string: "https://productpoke.notion.site/Shoots-e6565357d2704e3694aa622a0d854b46")!
                                #if os(iOS)
                                    UIApplication.shared.open(url)
                                #else
                                    NSWorkspace.shared.open(url)
                                #endif
                            }) {
                                Text("使用协议")
                                    .bold()
                                    .foregroundColor(Color.shootRed)
                                    .fixedSize()
                            }.buttonStyle(.plain)

                            Group {
                                Spacer()
                                Text("·")
                                    .bold()
                                    .foregroundColor(Color.shootRed)
                                    .fixedSize()
                                Spacer()
                                Button(action: {
                                    #if os(iOS)
                                        UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
                                    #else
                                        NSWorkspace.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
                                    #endif
                                }) {
                                    Text("订阅管理")
                                        .bold()
                                        .foregroundColor(Color.shootRed)
                                        .fixedSize()
                                }.buttonStyle(.plain)
                                Spacer()
                            }
                        }
                    }.padding(.top, 10)
                }
                .padding()
                #if os(iOS)
                .padding(.horizontal, iPhonelandscape ? 46 : 0)
                #endif
            }
        }.background(Color.shootWhite)
            .safeAreaInset(edge: .bottom) {
                bottomButton
            }
            .background(Color.shootWhite)
            .toast(isPresenting: $showToast) {
                AlertToast(displayMode: .alert, type: .systemImage("drop.triangle.fill", .red), title: toastText)
            }
            .onAppear {
                getInfo()
                #if os(iOS)
                autoScroll()
                #endif
            }
        #if os(iOS)
            .onChange(of: selectedTab) { newValue in
                timer?.invalidate()
                autoScroll()
            }
        #else
            .overlay (
                MacCloseButton(color: .shootWhite).padding(), alignment: .topTrailing
            )
        #endif
    }
    
    var content: some View {
        #if os(iOS)
        TabView(selection: $selectedTab) {
            Image("01")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(26)
                .tag(0)
            Image("02")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding( 26)
                .tag(1)
            Image("03")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding( 26)
                .tag(2)
            Image("05")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding( 26)
                .tag(3)
            Image("04")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(26)
                .tag(4)
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity)
            .padding([.top, .horizontal])
            .frame(height: 420)
            .background(LinearGradient(colors: [.pink.opacity(0.4), .purple.opacity(0.4), .yellow.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing).padding([.horizontal, .top], -20).blur(radius: 20))
            .padding(.bottom)
            .overlay(
                WaveView(waveColor: .shootWhite, progress: 0.2)
                    .overlay(
                        HStack(spacing: 4) {
                            ForEach(0...3, id: \.self) { index in
                                Circle()
                                    .frame(width: 6, height: 6)
                                    .foregroundColor(selectedTab == index ? .shootBlue : .shootGray.opacity(0.2))
                                    .animation(.spring(), value: selectedTab)
                            }
                        }, alignment: .bottom
                    )
                , alignment: .bottom
            )
        #else
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom) {
                VStack {
                    Image("01")
                    macTitleView(selectedTab: 0)
                }.frame(maxWidth: 460)
                VStack {
                    Image("02")
                    macTitleView(selectedTab: 1)
                }.frame(maxWidth: 460)
                VStack {
                    Image("03")
                    macTitleView(selectedTab: 2)
                }.frame(maxWidth: 460)
                VStack {
                    Image("05")
                    macTitleView(selectedTab:3)
                }.frame(maxWidth: 460)
                VStack {
                    Image("04")
                    macTitleView(selectedTab: 4)
                }.frame(maxWidth: 460)
            }.padding(.top, 36)
        }
        .background(LinearGradient(colors: [.pink.opacity(0.4), .purple.opacity(0.4), .yellow.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .padding(.bottom)
        .overlay(
            WaveView(waveColor: .shootWhite, progress: 0.2)
            , alignment: .bottom
        )
        #endif
    }
    #if os(iOS)
    var iOSTitleView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text(LocalizedStringKey(titles[selectedTab].indicator))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.shootWhite)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(LinearGradient(colors: [.pink, .yellow, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Capsule())
                    .animation(nil, value: selectedTab)
                
                Text(LocalizedStringKey(titles[selectedTab].title))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.shootBlack)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .animation(nil, value: selectedTab)
            }.frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
                .padding(.top)
                .padding(.horizontal)
            
            if #available(iOS 16.0, macOS 15.0, *) {
                Text(LocalizedStringKey(titles[selectedTab].subtitle))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.shootGray)
                    .lineLimit(3, reservesSpace: true)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 36)
                    .padding(.horizontal)
                    .animation(nil, value: selectedTab)
            } else {
                Text(LocalizedStringKey(titles[selectedTab].subtitle))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.shootGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 36)
                    .padding(.horizontal)
                    .animation(nil, value: selectedTab)
            }
        }.background(Color.shootWhite)
    }
    #endif
    
    func macTitleView(selectedTab: Int = 0) -> some View {
        Group {
            VStack(spacing: 8) {
                Text(LocalizedStringKey(titles[selectedTab].indicator))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.shootWhite)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(LinearGradient(colors: [.pink, .yellow, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Capsule())
                    .animation(nil, value: selectedTab)
                
                Text(LocalizedStringKey(titles[selectedTab].title))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.shootBlack)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .animation(nil, value: selectedTab)
            }.frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
                .padding(.top)
                .padding(.horizontal)
            
            if #available(iOS 16.0, macOS 12.0, *) {
                Text(LocalizedStringKey(titles[selectedTab].subtitle))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.shootGray)
                    .lineLimit(3, reservesSpace: true)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 36)
                    .padding(.horizontal, 36)
                    .animation(nil, value: selectedTab)
            } else {
                Text(LocalizedStringKey(titles[selectedTab].subtitle))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.shootGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 36)
                    .padding(.horizontal, 36)
                    .animation(nil, value: selectedTab)
            }
        }
    }
    var priceView: some View {
        VStack {
            HStack {
                Button(action: {
                    //
                    #if os(iOS)
                    FeedbackManager.impact(style: .soft)
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                        selected = .month
                    }
                    #else
                    selected = .month
                    #endif
                }, label: {
                    Color.shootBlue.opacity(selected == .month ? 0.2 : 0.1)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(3)
                        .overlay(
                            VStack {
                                Text("按月付费")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.shootBlack)
                                Spacer(minLength: 0)
                                Text(monthMoney)
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.shootBlue)
                                    .fixedSize()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer(minLength: 0)
                                Text("每月")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.shootGray)
                            }.padding()
                        )
                        
                        .overlay(
                            Group {
                                if selected == .month {
                                    selectedView
                                }
                            }
                        )
                        .scaleEffect(x: selected == .month ? 1.08 : 1, y: selected == .month ? 1.08 : 1, anchor: .center)
                        .overlay (
                            Group {
                                if selected == .month {
                                    Text("7 天试用")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.shootWhite)
                                        .textCase(.uppercase)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .modifier(GradientModifier(color: Color.shootBlue))
                                        .clipShape(Capsule())
                                        .offset(y: -14)
                                        .transition(AnyTransition.asymmetric(
                                            insertion: .move(edge: .top).combined(with: .opacity),
                                            removal: .move(edge: .top).combined(with: .scale(scale: 0, anchor: .top))
                                        ))
                                }
                            }, alignment: .top
                        )
                }).buttonStyle(PlainButtonStyle())
                
                
                Button(action: {
                    //
                    #if os(iOS)
                    FeedbackManager.impact(style: .soft)
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                        selected = .year
                    }
                    #else
                    selected = .year
                    #endif
                }, label: {
                    Color.shootBlue.opacity(selected == .year ? 0.2 : 0.1)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(3)
                        .overlay(
                            VStack {
                                Text("按年付费")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.shootBlack)
                                Spacer(minLength: 0)
                                Text(yearMoney)
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.shootBlue)
                                    .fixedSize()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer(minLength: 0)
                                Text("\(yearMoneyString) /月")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.shootGray)
                            }.padding()
                        )
                        .overlay(
                            Group {
                                if selected == .year {
                                    selectedView
                                }
                            }
                        )
                        .scaleEffect(x: selected == .year ? 1.08 : 1, y: selected == .year ? 1.08 : 1, anchor: .center)
                        .overlay (
                            Group {
                                if selected == .year {
                                    Text("30 天试用")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.shootWhite)
                                        .textCase(.uppercase)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .modifier(GradientModifier(color: Color.shootBlue))
                                        .clipShape(Capsule())
                                        .offset(y: -14)
                                        .transition(AnyTransition.asymmetric(
                                            insertion: .move(edge: .top).combined(with: .opacity),
                                            removal: .move(edge: .top).combined(with: .scale(scale: 0, anchor: .top))
                                        ))
                                }
                            }, alignment: .top
                        )
                }).buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    //
                    #if os(iOS)
                    FeedbackManager.impact(style: .soft)
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                        selected = .life
                    }
                    #else
                    selected = .life
                    #endif
                }, label: {
                    Color.shootBlue.opacity(selected == .life ? 0.2 : 0.1)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(3)
                        .overlay(
                            VStack {
                                Text("永久买断")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.shootBlack)
                                Spacer(minLength: 0)
                                Text(lifeHalfMoney)
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.shootBlue)
                                    .fixedSize()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer(minLength: 0)
                                Text("\(lifeMoney)")
                                    .font(.system(size: 18, weight: .medium))
                                    .strikethrough(true, color: .shootRed)
                                    .foregroundColor(.shootGray)
                            }.padding()
                        )
                        .overlay(
                            Group {
                                if selected == .life {
                                    selectedView
                                }
                            }
                        )
                        .scaleEffect(x: selected == .life ? 1.08 : 1, y: selected == .life ? 1.08 : 1, anchor: .center)
                        .overlay (
                            Text("40% 优惠")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.shootWhite)
                                .textCase(.uppercase)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .modifier(GradientModifier(color: Color.shootRed))
                                .clipShape(Capsule())
                                .offset(y: -14)
                                .transition(AnyTransition.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .scale(scale: 0, anchor: .top))
                                ))
                            , alignment: .top
                        )
                }).buttonStyle(PlainButtonStyle())
            }.padding(.horizontal, 10)
        }
    }
    
    var bottomButton: some View {
        VStack {
            Button {
                if !showYearLoadingIndicator && !showBuyLoadingIndicator {
                    withAnimation(.spring()) {
                        showBuyLoadingIndicator = true
                    }
                    purchase(id: selected.id)
                }
            } label: {
                HStack {
                    if showBuyLoadingIndicator {
                        ActivityIndicatorView(isVisible: self.$showBuyLoadingIndicator, type: .arcs, text: "", width: 28)
                            .foregroundColor(.white)
                    } else {
                        Text(LocalizedStringKey(selected.buttonTitle))
                            .font(.system(size: 16, weight: .bold))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                    }
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: showBuyLoadingIndicator ? nil : .infinity)
                .modifier(GradientModifier(color: Color.shootBlue))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .frame(maxWidth: 414)
                .contentShape(Rectangle())
            }.buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        #if os(iOS)
        .padding(.bottom, Device.isPad() ? 12 : 0)
        #else
        .padding(.bottom, 12)
        #endif
        .background(Color.shootWhite)
        .shadow(color: .shootGray.opacity(0.1), radius: 10, x: 0, y: -4)
    }
    
    func getInfo() {
        showBuyLoadingIndicator = true
        SwiftyStoreKit.retrieveProductsInfo([Support.year.id, Support.month.id, Support.life.id]) { result in
            if !result.retrievedProducts.isEmpty {
                result.retrievedProducts.forEach { product in
                    if product.productIdentifier == Support.year.id {
                        yearMoney = product.localizedPrice!
                        yearMoneyString = product.localizedPriced
                    } else if product.productIdentifier == Support.month.id {
                        monthMoney = product.localizedPrice!
                        
                    } else if product.productIdentifier == Support.life.id {
                        lifeHalfMoney = product.localizedPrice!
                        
                    } else if product.productIdentifier == Support.lifeHalf.id {
                        lifeMoney = product.localizedPrice!
                    }

                    let priceString = product.localizedPrice!
                    print("Product: \(product.localizedDescription), price: \(priceString), id: \(product.productIdentifier)")
                }
                showBuyLoadingIndicator = false
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
                showBuyLoadingIndicator = false
            } else {
                print("Error: \(result.error)")
                showBuyLoadingIndicator = false
            }
        }
    }

    func purchase(id: String) {
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
            switch result {
            case let .success(purchase):
                print("Purchase Success: \(purchase.productId)")

                // 购买成功，修改 UI 状态以及给用户提示信息
                Defaults().set(true, for: .pro)
                counter += 1

                withAnimation(.spring()) {
                    showYearLoadingIndicator = false
                    showBuyLoadingIndicator = false
                }
                #if os(iOS)
                    let alertView = SPAlertView(title: "已经购买成功".localized, message: "感谢支持，可以使用所有功能！".localized, preset: .done)
                    alertView.backgroundColor = .gray
                    alertView.present()
                #else
                    toastText = "感谢支持，可以使用所有功能！"
                    showToast.toggle()
                #endif
            case let .error(error):
                switch error.code {
                case .paymentCancelled:
                    withAnimation(.spring()) {
                        showYearLoadingIndicator = false
                        showBuyLoadingIndicator = false
                    }
                    #if os(iOS)
                        let alertView = SPAlertView(title: "取消购买".localized, message: "已经取消购买！".localized, preset: .error)
                        alertView.backgroundColor = .gray
                        alertView.present()
                    #else
                        toastText = "已经取消购买！"
                        showToast.toggle()
                    #endif

                case .unknown: print((error as NSError).localizedDescription)
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
                withAnimation(.spring()) {
                    showYearLoadingIndicator = false
                    showBuyLoadingIndicator = false
                }
                #if os(iOS)
                let alertView = SPAlertView(title: "购买失败".localized, message: "购买出现问题，请稍后重试！".localized, preset: .error)
                alertView.backgroundColor = .gray
                alertView.present()
                #else
                toastText = "购买出现问题，请稍后重试！"
                showToast.toggle()
                #endif
            }
        }
    }

    func restore() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                // 回复购买失败，提示用户稍后重试
                withAnimation(.spring()) {
                    showYearLoadingIndicator = false
                    showBuyLoadingIndicator = false
                }
                #if os(iOS)
                    let alertView = SPAlertView(title: "恢复购买失败".localized, message: "恢复购买出现问题，请稍后重试！".localized, preset: .error)
                    alertView.backgroundColor = .gray
                    alertView.present()
                #else
                    toastText = "恢复购买出现问题，请稍后重试！"
                    showToast.toggle()
                #endif

            } else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                // 恢复购买成功，调取获取凭证方法
                Defaults().set(true, for: .pro)
                counter += 1
                withAnimation(.spring()) {
                    showYearLoadingIndicator = false
                    showBuyLoadingIndicator = false
                }

                #if os(iOS)
                    let alertView = SPAlertView(title: "恢复购买成功".localized, message: "已经恢复购买成功，可以使用所有功能！".localized, preset: .done)
                    alertView.backgroundColor = .gray
                    alertView.present()
                #else
                    toastText = "已经恢复购买成功，可以使用所有功能！"
                    showToast.toggle()
                #endif

            } else {
                print("Nothing to Restore")
                // 之前没买过东西，无法恢复购买
                withAnimation(.spring()) {
                    showYearLoadingIndicator = false
                    showBuyLoadingIndicator = false
                }
                #if os(iOS)
                    let alertView = SPAlertView(title: "未购买任何产品".localized, message: "没有任何付费信息，无法恢复！".localized, preset: .done)
                    alertView.backgroundColor = .gray
                    alertView.present()
                #else
                    toastText = "没有任何付费信息，无法恢复！"
                    showToast.toggle()
                #endif
            }
        }
    }

    #if os(iOS)
        var trailing: some View {
            Group {
                if horizontalSizeClass == .regular && verticalSizeClass == .compact {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color.shootRed)
                    }
                }
            }
        }
    #endif

    @Namespace var selection
    var selectedView: some View {
        Color.clear
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.shootBlue, lineWidth: 2)
            )
            .matchedGeometryEffect(id: "selection", in: selection)
    }
    
    #if os(iOS)
    func autoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            if selectedTab < 3 {
                withAnimation(.linear(duration: 1)) {
                    selectedTab += 1
                }
            } else {
                withAnimation(.spring()) {
                    selectedTab = 0
                }
            }
        }
    }
    #endif
}

struct ProView_Previews: PreviewProvider {
    static var previews: some View {
        ProView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))

        ProView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}


enum Support: String {
    case month
    case year
    case life
    case lifeHalf

    var id: String {
        switch self {
        case .month:
            return "com.poke.preview.month"
        case .year:
            return "com.poke.preview.year"
        case .life:
            return "com.poke.shoots.rich.half"
        case .lifeHalf:
            return "com.poke.shoots.rich"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .month:
            return "免费试用 7 天"
        case .year:
            return "免费试用 30 天"
        case .life:
            return "立即购买，40% 优惠"
        default:
            return ""
        }
    }
    
    var selectionText: String {
        switch self {
        case .month:
            return "7 天试用"
        case .year:
            return "30 天试用"
        case .life:
            return "40% 优惠"
        default:
            return ""
        }
    }
}


extension SKProduct {
    var localizedPriced: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price.dividing(by: 12))!
    }
}
