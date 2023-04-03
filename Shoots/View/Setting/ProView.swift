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
    
    @State var showLoadingIndicator = false
    var yearhalf = "com.notes.yeayly.half"
    var year = "com.notes.yeayly"
    var lifehalf = "com.notes.lifetime.half"
    var life = "com.notes.lifetime"
    
    @State var yearhalfMoney = "¥18.00"
    @State var yearMoney = "¥24.00"
    @State var lifehalfMoney = "¥128.00"
    @State var lifeMoney = "¥60.00"
    
    @State var counter: Int = 0
    
    var body: some View {
        ZStack {
            #if os(iOS)
            NavigationView {
                content
                    .navigationTitle("支持开发者")
                    .navigationBarItems(trailing: trailing)
                    .background(Color("bg"))
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
            }
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
            }.background(Color("bg"))
            #endif
            ConfettiCannon(counter: $counter, num: 300, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 400)
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
                VStack {
                    Text("升级为 Pro 使用预览全部功能")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color.shootBlack)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    if !(Defaults().get(for: .pro) ?? false) {
                        HStack {
                            Text("12")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.white)
                            + Text("天 Pro 功能试用，剩余")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.white)
                            + Text("10")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.white)
                            + Text("天")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.white)
                        }
                        .padding(6)
                        .background(Color.shootRed)
                        .clipShape(RoundedCornersShape(tl: 10, tr: 0, bl: 0, br: 10))
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                
                imageView
                
                if !(Defaults().get(for: .pro) ?? false) {
                    if self.showLoadingIndicator {
                        HStack {
                            ActivityIndicatorView(isVisible: self.$showLoadingIndicator, type: .arcs)
                                .frame(width: 50.0, height: 50.0)
                                .foregroundColor(.red)
                        }.frame(maxWidth: .infinity)
                            .frame(height: 247)
                            .padding(.bottom, 30)
                            .cornerRadius(20)
                            .shadow(color: Color.shootBlack.opacity(0.08), radius: 10, x: 0, y: 16)
                    } else {
                        buyButton
                            .frame(height: 247)
                    }
                }
                
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
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
    }
    
    func getInfo() {
        showLoadingIndicator = true
        SwiftyStoreKit.retrieveProductsInfo([year, yearhalf, life, lifehalf]) { result in
            if !result.retrievedProducts.isEmpty {
                result.retrievedProducts.forEach { product in
                    if product.productIdentifier == yearhalf {
                        yearhalfMoney = product.localizedPrice!
                    } else if product.productIdentifier == year {
                        yearMoney = product.localizedPrice!
                    } else if product.productIdentifier == lifehalf {
                        lifehalfMoney = product.localizedPrice!
                    } else if product.productIdentifier == life {
                        lifeMoney = product.localizedPrice!
                    }
                    
                    
                    let priceString = product.localizedPrice!
                    print("Product: \(product.localizedDescription), price: \(priceString), id: \(product.productIdentifier)")
                }
                showLoadingIndicator = false
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
                showLoadingIndicator = false
            } else {
                print("Error: \(result.error)")
                showLoadingIndicator = false
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
                self.showLoadingIndicator = false
                if true {
//                    let alertView = SPAlertView(title: "已经购买成功", message: "感谢您对 Poke 的支持，可以使用所有功能！", preset: .done)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                } else {
//                    let alertView = SPAlertView(title: "Purchased Successfully", message: "Thank you for supporting Poke, now you have access to all features!", preset: .done)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                }
            case .error(let error):
                switch error.code {
                case .paymentCancelled:
                    self.showLoadingIndicator = false
                    if true {
//                        let alertView = SPAlertView(title: "取消购买", message: "已经取消购买！", preset: .error)
//                        alertView.backgroundColor = .gray
//                        alertView.present()
                    } else {
//                        let alertView = SPAlertView(title: "Cancel Purchase", message: "You cancel the purchase!", preset: .error)
//                        alertView.backgroundColor = .gray
//                        alertView.present()
                    }
                    
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
                self.showLoadingIndicator = false
                if true {
//                    let alertView = SPAlertView(title: "购买失败", message: "购买出现问题，请稍后重试！", preset: .error)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                } else {
//                    let alertView = SPAlertView(title: "Purchase Failure", message: "A problem occured, please try again later!", preset: .error)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                }
            }
        }
    }
    
    func restore() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                //回复购买失败，提示用户稍后重试
                self.showLoadingIndicator = false
                
                if true {
//                    let alertView = SPAlertView(title: "恢复购买失败", message: "购买出现问题，请稍后重试！", preset: .error)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                } else {
//                    let alertView = SPAlertView(title: "Resume Purchase Failed", message: "A problem occured, please try again later!", preset: .error)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                }
                
            } else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                //恢复购买成功，调取获取凭证方法
                Defaults().set(true, for: .pro)
                counter += 1
                self.showLoadingIndicator = false
                
                if true {
//                    let alertView = SPAlertView(title: "恢复购买成功", message: "已经恢复购买成功，可以使用所有功能！", preset: .done)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                } else {
//                    let alertView = SPAlertView(title: "Resume Purchase Successful", message: "The purchase has been resumed successfully, all functions can be used!", preset: .done)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                }
                
            } else {
                print("Nothing to Restore")
                //之前没买过东西，无法恢复购买
                self.showLoadingIndicator = false
                if true {
//                    let alertView = SPAlertView(title: "未购买任何产品", message: "没有任何付费信息，无法恢复！", preset: .done)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                } else {
//                    let alertView = SPAlertView(title: "Nothing Purchased", message: "No payment information, unable to recover!", preset: .done)
//                    alertView.backgroundColor = .gray
//                    alertView.present()
                }
            }
        }
    }
    
    var imageView: some View {
        VStack(spacing: 26) {
            Color.red
                .frame(height: 206)
        }.padding(.top, 16).padding(.bottom, 26)
    }
    
    var buyButton: some View {
        VStack(spacing: 10) {
            VStack {
                Text("按年付费")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.shootBlack)
                Button {
                    showLoadingIndicator = true
                    if daysLeft > 0 {
                        purchase(id: yearhalf)
                    } else {
                        purchase(id: year)
                    }
                } label: {
                    HStack {
                        if daysLeft > 0 {
                            Text("\(yearhalfMoney)")
                                .font(.system(size: 16, weight: .bold))
                            + Text(" (\(yearMoney)) ")
                                .font(.system(size: 13, weight: .bold))
                                .strikethrough()
                            + Text(" 每年")
                                .font(.system(size: 16, weight: .bold))
                            + Text("，节省 45% 每年")
                                .font(.system(size: 16, weight: .bold))
                        } else {
                            Text("试用期结束，\(yearMoney) 每年")
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .foregroundColor(Color.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.shootYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .frame(maxWidth: 414)
                    .contentShape(Rectangle())
                }.buttonStyle(PlainButtonStyle())
            }.padding(.bottom, 26)
            
            VStack {
                Text("一次性付费，终身免费更新")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.shootBlack)
                Button {
                    showLoadingIndicator = true
                    if daysLeft > 0 {
                        purchase(id: lifehalf)
                    } else {
                        purchase(id: life)
                    }
                } label: {
                    HStack {
                        if daysLeft > 0 {
                            Text("\(lifehalfMoney) ")
                                .font(.system(size: 16, weight: .bold))
                            + Text("(\(lifeMoney)) ")
                                .font(.system(size: 13, weight: .bold))
                                .strikethrough()
                            + Text("，节省 50%")
                                .font(.system(size: 16, weight: .bold))
                        } else {
                            Text("试用期结束，\(lifeMoney)")
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .foregroundColor(Color.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.shootRed)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .frame(maxWidth: 414)
                    .contentShape(Rectangle())
                }.buttonStyle(PlainButtonStyle())
            }
            
            Button {
                showLoadingIndicator = true
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
        }.padding(.top, 26).padding(.horizontal)
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
}


struct ProView_Previews: PreviewProvider {
    static var previews: some View {
        ProView()
    }
}

