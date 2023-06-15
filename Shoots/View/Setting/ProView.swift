//
//  ProView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/22.
//

import SwiftUI
#if os(iOS)
import MessageUI
#endif

struct ProView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var showPrivacy = false
    @State var showAgreement = false
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
    #endif
    
    @State var showBuyLoadingIndicator = false
    @State var showYearLoadingIndicator = false
    enum Support: String {
        case year
        case drink
        case milk
        case coffee
        case rich
        
        var id: String {
            switch self {
            case .year:
                return "com.poke.preview.year"
            case .drink:
                return "com.poke.shoots.drink"
            case .milk:
                return "com.poke.shoots.milk"
            case .coffee:
                return "com.poke.shoots.coffee"
            case .rich:
                return "com.poke.shoots.rich"
            }
        }
    }
    
    @State var yearMoney = "¥18.00"
    @State var drinkMoney = "¥12.00"
    @State var milkMoney = "¥18.00"
    @State var coffeeMoney = "¥28.00"
    @State var richMoney = "¥28.00"
    
    @State var counter: Int = 0
    @State var showToast = false
    @State var toastText = ""
    var body: some View {
        ZStack {
            #if os(iOS)
            NavigationView {
                content
                    .navigationTitle("支持开发者")
                    .navigationBarItems(trailing: trailing)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
            }.background(Color.shootWhite)
            .navigationViewStyle(StackNavigationViewStyle())
            #else
            VStack {
                HStack {
                    Text("支持开发者")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    MacCloseButton()
                }.padding([.horizontal, .top], 36)
                
                content
            }.background(Color.shootWhite)
            #endif
            ConfettiCannon(counter: $counter, num: 300, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 400)
        }
        .background(Color.shootWhite)
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .systemImage("drop.triangle.fill", .red), title: toastText)
        }
        .overlay(
            Group {
                if (Defaults().get(for: .pro) ?? false) {
                    Image("pro")
                } else if 10 != 0 {
                    Image("discount")
                }
            }
            #if os(iOS)
                .offset(x: Device.isPad() ? -20 : 0, y: Device.isPad() ? 20 : 10)
            #endif
            , alignment: .topTrailing
        )
        .onAppear {
            getInfo()
        }
    }
    
    var content: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Text("获取更多的特殊权益")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color.shootBlack)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                imageView
                
                buyButton
                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        Text("\(Image(systemName: "bell.circle.fill"))")
                            .foregroundColor(Color.shootRed)
                        + Text(" 按年付费确认订阅之后将会向您的 App Store 账户收取费用，按照年的时间长度收取您的费用。订阅服务将会在当前周期结束时自动续订并收取下一年的费用。")
                            .foregroundColor(Color.shootBlack)
                    }
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    Group {
                        Text("\(Image(systemName: "bell.circle.fill"))")
                            .foregroundColor(Color.shootRed)
                        + Text(" 取消自动续订需要在当前订阅周期结束前 24 小时完成，可以在下面的 App Store 订阅管理里查看，如果有任何问题，请联系我们。")
                            .foregroundColor(Color.shootBlack)
                    }
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showAgreement = true
                            }) {
                                Text("隐私条款")
                                    .bold()
                                    .foregroundColor(Color.shootRed)
                                    .fixedSize()
                            }.buttonStyle(.plain)
                            .sheet(isPresented: self.$showAgreement) {
                                PrivacyView(showPrivacy: self.$showPrivacy)
                            }
                            
                            Spacer()
                            Text("·")
                                .bold()
                                .foregroundColor(Color.shootRed)
                                .fixedSize()
                            Spacer()
                            
                            Button(action: {
                                self.showPrivacy = true
                            }) {
                                Text("使用协议")
                                    .bold()
                                    .foregroundColor(Color.shootRed)
                                    .fixedSize()
                            }.buttonStyle(.plain)
                            .sheet(isPresented: self.$showPrivacy) {
                                AgreementView(showAgreement: self.$showAgreement)
                            }
                            
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
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }
    
    func getInfo() {
        showBuyLoadingIndicator = true
        SwiftyStoreKit.retrieveProductsInfo([Support.year.id, Support.drink.id, Support.milk.id, Support.coffee.id, Support.rich.id]) { result in
            if !result.retrievedProducts.isEmpty {
                result.retrievedProducts.forEach { product in
                    if product.productIdentifier == Support.year.id {
                        yearMoney = product.localizedPrice!
                    } else if product.productIdentifier == Support.drink.id {
                        drinkMoney = product.localizedPrice!
                    } else if product.productIdentifier == Support.milk.id {
                        milkMoney = product.localizedPrice!
                    } else if product.productIdentifier == Support.coffee.id {
                        coffeeMoney = product.localizedPrice!
                    } else if product.productIdentifier == Support.rich.id {
                        richMoney = product.localizedPrice!
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
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                
                //购买成功，修改 UI 状态以及给用户提示信息
                Defaults().set(true, for: .pro)
                counter += 1
                self.showBuyLoadingIndicator = false
                #if os(iOS)
                let alertView = SPAlertView(title: "已经购买成功".localized, message: "感谢支持，可以使用所有功能！".localized, preset: .done)
                alertView.backgroundColor = .gray
                alertView.present()
                #else
                toastText = "感谢支持，可以使用所有功能！"
                showToast.toggle()
                #endif
            case .error(let error):
                switch error.code {
                case .paymentCancelled:
                    self.showBuyLoadingIndicator = false
                    #if os(iOS)
                    let alertView = SPAlertView(title: "取消购买".localized, message: "已经取消购买！".localized, preset: .error)
                    alertView.backgroundColor = .gray
                    alertView.present()
                    #else
                    toastText = "已经取消购买！"
                    showToast.toggle()
                    #endif
                    
                    break
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
                self.showBuyLoadingIndicator = false
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
                //回复购买失败，提示用户稍后重试
                self.showBuyLoadingIndicator = false
                #if os(iOS)
                let alertView = SPAlertView(title: "恢复购买失败".localized, message: "购买出现问题，请稍后重试！".localized, preset: .error)
                alertView.backgroundColor = .gray
                alertView.present()
                #else
                toastText = "购买出现问题，请稍后重试！"
                showToast.toggle()
                #endif
                
            } else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                //恢复购买成功，调取获取凭证方法
                Defaults().set(true, for: .pro)
                counter += 1
                self.showBuyLoadingIndicator = false
                
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
                //之前没买过东西，无法恢复购买
                self.showBuyLoadingIndicator = false
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
    
    @State var selected: Support = .drink
    var buyButton: some View {
        VStack(spacing: 16) {
            drinkView
            
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
                        ActivityIndicatorView(isVisible: self.$showBuyLoadingIndicator, type: .arcs, width: 28)
                            .foregroundColor(.white)
                    } else {
                        Text("支持开发者")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                    }
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .background(Color.shootRed)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .frame(maxWidth: 414)
                .contentShape(Rectangle())
            }.buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            Button {
                if !showYearLoadingIndicator && !showBuyLoadingIndicator {
                    withAnimation(.spring()) {
                        showYearLoadingIndicator = true
                    }
                    purchase(id: Support.year.id)
                }
            } label: {
                HStack {
                    if showYearLoadingIndicator {
                        ActivityIndicatorView(isVisible: self.$showYearLoadingIndicator, type: .arcs, width: 28)
                            .foregroundColor(.white)
                    } else {
                        Text("每年支持 \(yearMoney)")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                    }
                }
                .foregroundColor(Color.white)
                
                .frame(maxWidth: .infinity)
                .background(Color.shootYellow)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .frame(maxWidth: 414)
                .contentShape(Rectangle())
            }.buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
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
        }.padding(.top, 26)
    }
    
    var drinkView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom) {
                Button(action: {
                    #if os(iOS)
                    FeedbackManager.impact(style: .medium)
                    #endif
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                        selected = .drink
                    }
                }) {
                    VStack(spacing: 16) {
                        Image("coco")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 108, height: 108)
                        Text("一瓶饮料 (\(drinkMoney))")
                            .foregroundColor(Color.shootBlack)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .padding(20)
                    .overlay(
                        Group {
                            if selected == .drink {
                                selectedView
                            }
                        }
                    )
                }
                
                Button(action: {
                    #if os(iOS)
                    FeedbackManager.impact(style: .medium)
                    #endif
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                        selected = .milk
                    }
                }) {
                    VStack(spacing: 16) {
                        Image("naicha")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 108, height: 108)
                        Text("一杯奶茶 (\(milkMoney))")
                            .foregroundColor(Color.shootBlack)
                            .font(.system(size: 12, weight: .medium))
                    }.padding(20)
                        .overlay(
                            Group {
                                if selected == .milk {
                                    selectedView
                                }
                            }
                        )
                }
                
                Button(action: {
                    #if os(iOS)
                    FeedbackManager.impact(style: .medium)
                    #endif
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                        selected = .coffee
                    }
                }) {
                    VStack(spacing: 16) {
                        Image("coffee01")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 108, height: 108)
                        Text("一杯咖啡 (\(coffeeMoney))")
                            .foregroundColor(Color.shootBlack)
                            .font(.system(size: 12, weight: .medium))
                    }.padding(20)
                        .overlay(
                            Group {
                                if selected == .coffee {
                                    selectedView
                                }
                            }
                        )
                }
                
                Button(action: {
                    #if os(iOS)
                    FeedbackManager.impact(style: .medium)
                    #endif
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                        selected = .rich
                    }
                }) {
                    VStack(spacing: 16) {
                        Image("coffee01")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 108, height: 108)
                        Text("大额大赏 (\(richMoney))")
                            .foregroundColor(Color.shootBlack)
                            .font(.system(size: 12, weight: .medium))
                    }.padding(20)
                        .overlay(
                            Group {
                                if selected == .rich {
                                    selectedView
                                }
                            }
                        )
                }
            }.padding(.horizontal)
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
                    .stroke(Color.shootRed, lineWidth: 2)
                    .padding(6)
            )
            .matchedGeometryEffect(id: "selection", in: selection)
    }
    
    var imageView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    Image("03")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                        .frame(height: 260)
                    Text("优先获得 AI 设计功能")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.shootBlack)
                }
                
                VStack(spacing: 6) {
                    Image("02")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                        .frame(height: 260)
                    
                    Text("不限制截图的数量")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.shootBlack)
                }
                
                VStack(spacing: 6) {
                    Image("01")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                        .frame(height: 260)
                    Text("更多高级功能")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.shootBlack)
                }
            }
                .padding(.top, 16)
                .padding(.bottom, 26)
        }.background(Color.shootLight.opacity(0.06))
            .padding(.vertical)
    }
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

