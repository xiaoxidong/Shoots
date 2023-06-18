//
//  UploadView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI
import Alamofire

struct UploadView: View {
    @State var uploadImages: [UIImage]
    @Binding var uploadData: [LocalImageData]
    var shareExtension: Bool = false
    let shareCancellAction: () -> Void
    let shareDoneAction: () -> Void
    let uploadAction: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @AppStorage("showBlurNew") var showBlurNewGuide = true

    @State var updateIndicator = true
    let screen = UIScreen.main.bounds
    @State var selection: Int = 0
    @EnvironmentObject var user: UserViewModel
    @EnvironmentObject var info: InfoViewModel
    var body: some View {
        TabView(selection: $selection) {
            ForEach(uploadData.indices, id: \.self) { indice in
                Image(uiImage: UIImage(data: uploadData[indice].image)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screen.width, height: shareExtension ? nil : screen.height)
                    .ignoresSafeArea()
                    .tag(indice)
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                appFocused = false
                tagFocused = false
            }
            .edgesIgnoringSafeArea(shareExtension ? [] : .all)
            .safeAreaInset(edge: .top) {
                if horizontalSizeClass == .compact {
                    topActions
                        .background(Color.shootWhite)
                } else {
                    topActions
                        .padding(.top)
                        .background(Color.shootWhite)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if shareExtension {
                    bottomActions
                        .padding(.bottom)
                } else {
                    bottomActions
                }
            }
            .overlay(
                LoginView(login: $showLogin) {
                    upload()
                }, alignment: .bottom
            )
            .onChange(of: uploadImages) { newValue in
                withAnimation(.spring()) {
                    updateIndicator.toggle()
                }
            }
    }
    
    @State var showLogin = false
    var topActions: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    dismiss()
                    shareCancellAction()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.shootBlack)
                        .padding(4)
                        .contentShape(Rectangle())
                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
                if uploadImages.count < 2 {
                    Text("上传图片")
                        .font(.system(size: 14, weight: .medium))
                } else {
                    if updateIndicator {
                        TitlePageControll(progress: selection, numberOfPages: uploadImages.count, tintColor: UIColor(Color.shootLight), currentPageTintColor: UIColor(Color.shootBlue))
                            .frame(height: 24)
                    } else {
                        TitlePageControll(progress: selection, numberOfPages: uploadImages.count, tintColor: UIColor(Color.shootLight), currentPageTintColor: UIColor(Color.shootBlue))
                            .frame(height: 24)
                    }
                }
                Spacer(minLength: 0)
                Button {
                    // 如果未登录，先登录
                    if !user.login {
                        withAnimation(.spring()) {
                            showLogin.toggle()
                        }
                    } else {
                        upload()
                    }
                } label: {
                    Text("上传")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.shootBlue)
                        .padding(.horizontal, 6)
                        .contentShape(Rectangle())
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.padding(.horizontal)
            Divider()
        }.padding(.top, shareExtension ? 16 : 0)
    }
    
    @State var showBluer = false
    @State var showCombine = false
    var appRsults: [AppInfo] {
        if uploadData[selection].app == "" {
            return info.apps
        } else {
            return info.apps.filter({ $0.linkApplicationName.transToLowercasedPinYin().contains(uploadData[selection].app.transToLowercasedPinYin()) })
        }
    }
    var tagRsults: [Pattern] {
        if uploadData[selection].pattern.components(separatedBy: ",").last == "" {
            return info.patterns
        } else {
            return info.patterns.filter({ $0.designPatternName.transToLowercasedPinYin().contains(uploadData[selection].pattern.components(separatedBy: ",").last?.transToLowercasedPinYin() ?? "") })
        }
    }
    @FocusState var appFocused: Bool
    @FocusState var tagFocused: Bool
    
    var bottomActions: some View {
        VStack(spacing: 0) {
            if appFocused {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(appRsults) { app in
                            Button {
                                uploadData[selection].app = app.linkApplicationName
                                appFocused = false
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(app.linkApplicationName)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.shootBlack)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 16)
                                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                    Divider()
                                }.frame(width: .infinity, alignment: .leading)
                                    .background(Color.shootWhite)
                                    .contentShape(Rectangle())
                            }
                        }
                    }
                }.frame(maxHeight: 240)
                    .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    .shadow(color: Color.shootBlack.opacity(appFocused ? 0.06 : 0), x: 0, y: -6, blur: 10)
            } else if tagFocused {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(tagRsults, id: \.self) { tag in
                            Button {
                                if uploadData[selection].pattern == "" {
                                    uploadData[selection].pattern = "\(tag.designPatternName),"
                                } else if !uploadData[selection].pattern.contains(tag.designPatternName) {
                                    var new = uploadData[selection].pattern.components(separatedBy: ",")
                                    new.removeLast()
                                    uploadData[selection].pattern = new.joined(separator: ",") + ",\(tag.designPatternName),"
                                }
                            } label: {
                                VStack(alignment: .center, spacing: 0) {
                                    Text(tag.designPatternName)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.shootBlack)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 16)
                                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                    Divider()
                                }.frame(width: .infinity, alignment: .center)
                                    .background(Color.shootWhite)
                                    .contentShape(Rectangle())
                            }.buttonStyle(.plain)
                        }
                    }
                }.frame(maxHeight: 240)
                    .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    .shadow(color: Color.shootBlack.opacity(tagFocused ? 0.06 : 0), x: 0, y: -6, blur: 10)
            }
            VStack(spacing: 6) {
                Divider()
                HStack(spacing: 8) {
                    TextField("应用名称", text: $uploadData[selection].app)
                        .focused($appFocused)
                    Divider()
                        .frame(height: 36)
                    TextField("设计模式", text: $uploadData[selection].pattern)
                        .focused($tagFocused)
                    Button {
                        showBluer.toggle()
                    } label: {
                        Image("blur")
                            .padding(4)
                            .contentShape(Rectangle())
                    }

                    Button {
                        showCombine.toggle()
                        print("-------")
                    } label: {
                        Image("connect")
                            .padding(4)
                            .contentShape(Rectangle())
                    }
                }.padding(.horizontal)
            }
                .background(Color.shootWhite)
                .shadow(color: Color.shootBlack.opacity(appFocused || tagFocused ? 0 : 0.06), x: 0, y: -6, blur: 10)

        }
            .fullScreenCover(isPresented: $showBluer) {
                ImageBlurView(image: $uploadImages[selection])
                    .ignoresSafeArea()
//                    .overlay(alignment: .center) {
//                        blurNew
//                    }
            }
            .fullScreenCover(isPresented: $showCombine) {
                CombineSelectView(uploadImages: $uploadImages)
            }
            .onAppear {
                showBlurNewGuide = true
            }
    }
    
    var blurNew: some View {
        Group {
            if showBlurNewGuide {
                Color.black.opacity(0.5)
                VStack(spacing: 16) {
                    Image(systemName: "scribble.variable")
                        .font(.system(size: 56))
                        .foregroundColor(.shootWhite)
                    Text("双指缩放图片")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    Text("手指滑动打码敏感信息")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    
                    Button {
                        withAnimation(.spring()) {
                            showBlurNewGuide.toggle()
                        }
                    } label: {
                        Text("知道了")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 56)
                            .padding(.vertical, 12)
                            .background(LinearGradient(colors: [.pink, .yellow], startPoint: .leading, endPoint: .trailing))
                            .clipShape(Capsule())
                    }.padding(.top)
                }
            }
        }.ignoresSafeArea()
        .onTapGesture {
            withAnimation(.spring()) {
                showBlurNewGuide = false
            }
        }
    }
    
    func upload() {
        if let index = uploadData.firstIndex(where: { $0.app == "" }) {
            // 提示需要填写应用名称
            selection = index
        } else {
            if shareExtension {
                //上传截图
                Task {
                    user.uploadImages(localDatas: uploadData) { pics in
                        user.uploadPics(pics: pics) { success in
                            if success {
                                uploadData.removeAll()
                            } else {
                                
                            }
                        }
                    }
                }
                // 完成之后关闭
                shareDoneAction()
            } else {
                // 上传
                dismiss()
                //TODO: 后台上传截图
                uploadAction()
            }
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UploadView(uploadImages: [UIImage(named: "s1")!, UIImage(named: "s2")!], uploadData: .constant([])) {
                
            } shareDoneAction: {
                
            } uploadAction: {
                
            }
        }
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        NavigationView {
            UploadView(uploadImages: [UIImage(named: "s1")!, UIImage(named: "s2")!], uploadData: .constant([])) {
                
            } shareDoneAction: {
                
            } uploadAction: {
                
            }
        }
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
