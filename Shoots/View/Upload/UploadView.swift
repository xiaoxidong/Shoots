//
//  UploadView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import Alamofire
import SwiftUI

struct UploadView: View {
    @Binding var uploadData: [LocalImageData]
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
    @State var showToast = false
    @State var toastText = ""
    @State var alertType: AlertToast.AlertType = .success(Color.shootBlack)
    var body: some View {
        TabView(selection: $selection) {
            ForEach(uploadData.indices, id: \.self) { indice in
                Image(uiImage: UIImage(data: uploadData[indice].image)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screen.width, height: screen.height)
                    .ignoresSafeArea()
                    .tag(indice)
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                textFocused = .none
            }
            .edgesIgnoringSafeArea(.all)
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
                if !uploadData.isEmpty {
                    bottomActions
                }
            }
            .overlay(
                LoginView(login: $showLogin, successAction: {
                    upload()
                }, failAction: {}), alignment: .bottom
            )
            .toast(isPresenting: $showToast) {
                AlertToast(displayMode: .alert, type: alertType, title: toastText)
            }
            .onChange(of: selection, perform: { _ in
                if uploadData[selection].app == "" {
                    textFocused = .app
                } else if uploadData[selection].pattern == "" {
                    textFocused = .tag
                }
            })
            .onAppear {
                #if DEBUG
                    showBlurNewGuide = true
                #endif
            }
    }

    @State var showLogin = false
    var topActions: some View {
        VStack(spacing: 10) {
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
                if uploadData.count < 2 {
                    Text("上传图片")
                        .font(.system(size: 15, weight: .bold))
                } else {
                    if updateIndicator {
                        TitlePageControll(progress: selection, numberOfPages: uploadData.count, tintColor: UIColor(Color.shootBlack), currentPageTintColor: UIColor(Color.shootBlue))
                            .frame(height: 24)
                    } else {
                        TitlePageControll(progress: selection, numberOfPages: uploadData.count, tintColor: UIColor(Color.shootLight), currentPageTintColor: UIColor(Color.shootBlue))
                            .frame(height: 24)
                    }
                }
                Spacer(minLength: 0)
                Button {
                    // 如果未登录，先登录
                    if !user.login {
                        textFocused = .none
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
        }
    }

    @State var showBluer = false
    @State var showMessage = false
    @State var showCombine = false
    var appRsults: [AppInfo] {
        if uploadData[selection].app == "" {
            return info.apps
        } else {
            return info.apps.filter { $0.linkApplicationName.transToLowercasedPinYin().contains(uploadData[selection].app.transToLowercasedPinYin()) }
        }
    }

    var tagRsults: [Pattern] {
        if newTag == "" {
            return info.patterns
        } else {
            return info.patterns.filter { $0.designPatternName.transToLowercasedPinYin().contains(newTag.transToLowercasedPinYin()) }
        }
    }

    @FocusState var textFocused: TextFocuse?
    @State var showFullEditor = false
    enum TextFocuse {
        case app
        case tag
        case text
    }
    var bottomActions: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("输入描述信息")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.shootGray)
                        Spacer()
                        Button {
                            withAnimation(.spring()) {
                                showFullEditor.toggle()
                            }
                        } label: {
                            Group {
                                if showFullEditor {
                                    Image("down")
                                } else {
                                    Image("up")
                                }
                            }.padding([.horizontal], 6)
                                .contentShape(Rectangle())
                        }
                    }
                    
                    TextEditor(text: $uploadData[selection].description)
                        .focused($textFocused, equals: .text)
                        .font(.system(size: 16, weight: .medium))
                        .lineSpacing(3)
                        .accentColor(Color.shootBlue)
                }
                .padding(6)
                .frame(height: showFullEditor ? nil : 110)
                .frame(maxHeight: showFullEditor ? .infinity : nil)
                .background(Color.white)
                .opacity(textFocused == .text ? 1 : 0.001)
                
                if textFocused == .app {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(appRsults) { app in
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(app.linkApplicationName)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.shootBlack)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                    Divider()
                                }
                                .background(Color.shootWhite)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    uploadData[selection].app = app.linkApplicationName
                                    textFocused = .tag
                                }
                            }
                        }
                    }.frame(maxHeight: 240)
                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                        .shadow(color: Color.shootBlack.opacity(textFocused == .app ? 0.06 : 0), x: 0, y: -6, blur: 10)
                        .transition(.scale(scale: 0.9, anchor: .bottom).combined(with: .opacity))
                } else if textFocused == .tag {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(tagRsults, id: \.self) { tag in
                                VStack(alignment: .center, spacing: 0) {
                                    Text(tag.designPatternName)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.shootBlack)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(Color.shootWhite)
                                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                    Divider()
                                }.contentShape(Rectangle())
                                    .onTapGesture {
                                        if !uploadData[selection].tags.contains(tag.designPatternName) {
                                            uploadData[selection].tags.append(tag.designPatternName)
                                        }
                                        newTag = ""
                                    }
                            }
                        }
                    }.frame(maxHeight: 240)
                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                        .shadow(color: Color.shootBlack.opacity(textFocused == .tag ? 0.06 : 0), x: 0, y: -6, blur: 10)
                        .transition(.scale(scale: 0.9, anchor: .bottom).combined(with: .opacity))
                }
            }
            VStack(spacing: 6) {
                Divider()
                HStack(spacing: 0) {
                    TextField("应用名称", text: $uploadData[selection].app)
                        .focused($textFocused, equals: .app)
                        .font(.system(size: 14, weight: .medium))
                        .accentColor(Color.shootBlue)
                        .frame(width: 106)

                    Divider()
                        .frame(height: 36)
                    tag
                        .font(.system(size: 14, weight: .medium))
                    Button {
                        withAnimation(.spring()) {
                            if textFocused == .text {
                                textFocused = .app
                            } else {
                                textFocused = .text
                            }
                        }
                    } label: {
                        Image(textFocused == .text ? "messagefill" : "message")
                            .padding(4)
                            .padding(.horizontal, 4)
                            .contentShape(Rectangle())
                    }
                    
                    Menu {
                        Button {
                            
                        } label: {
                            Label("应用截图", systemImage: "photo.artframe")
                        }
                        Button {
                            
                        } label: {
                            Label("设计更新", systemImage: "lasso")
                        }
                        Button {
                            
                        } label: {
                            Label("用户体验", systemImage: "person.and.background.dotted")
                        }
                        Button {
                            
                        } label: {
                            Label("交互细节", systemImage: "sun.min")
                        }
                    } label: {
                        Image(systemName: "number")
                            .font(.system(size: 22, weight: .medium))
                            .padding(4)
                            .padding(.horizontal, 4)
                            .foregroundColor(.shootBlack)
                            .contentShape(Rectangle())
                    }

                    
                    
                    Button {
                        showBluer.toggle()
                    } label: {
                        Image("blur")
                            .padding(4)
                            .padding(.horizontal, 4)
                            .contentShape(Rectangle())
                    }

                    Button {
                        showCombine.toggle()
                    } label: {
                        Image("connect")
                            .padding(4)
                            .padding(.horizontal, 4)
                            .contentShape(Rectangle())
                    }
                }.padding(.horizontal, 8).padding(.bottom, 6)
            }
            .background(Color.shootWhite)
            .shadow(color: Color.shootBlack.opacity(textFocused == .app || textFocused == .tag ? 0 : 0.06), x: 0, y: -6, blur: 10)
        }
        .fullScreenCover(isPresented: $showBluer) {
            ImageBlurView(image: $uploadData[selection].image)
                .ignoresSafeArea()
                .overlay(alignment: .center) {
                    blurNew
                }
        }
        .fullScreenCover(isPresented: $showCombine) {
            CombineSelectView(uploadImages: $uploadData, selection: $selection, updateIndicator: $updateIndicator)
        }
        .onAppear {
            textFocused = .app
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
            alertType = .error(.red)
            toastText = "请添加所属应用"
            showToast = true
        } else {
            // 上传
            dismiss()
            // TODO: 后台上传截图
            uploadAction()
        }
    }

    // MARK: - Tag

//    @State public var tags: [String] = ["Apple", "Shoots"]
    @State private var newTag: String = ""
    var tag: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(uploadData[selection].tags, id: \.self) { tag in
                        Button(action: {
                            withAnimation {
                                uploadData[selection].tags.removeAll { $0 == tag }
                            }
                            newTag = ""
                        }) {
                            HStack(spacing: 4) {
                                Text(tag)
                                    .fixedSize()
                                    .foregroundColor(Color.shootBlue.opacity(0.8))
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .padding(.leading, 8)
                                    .padding(.vertical, 4)
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.shootBlue.opacity(0.8))
                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                                    .padding(.trailing, 8)
                            }.background(Color.shootBlue.opacity(0.12).cornerRadius(.infinity))
                                .contentShape(Rectangle())
                        }
                    }
                    TextField("换行输入多个标签", text: $newTag, onEditingChanged: { _ in
//                            appendNewTag()
                    }, onCommit: {
                        textFocused = .tag
                        appendNewTag()

                        // TODO: 输入完成的时候，不隐藏键盘
                        // https://stackoverflow.com/questions/69225415/swiftui-stay-on-same-textfield-after-on-commit
                        // https://github.com/mobilinked/MbSwiftUIFirstResponder
                    })
                    .focused($textFocused, equals: .tag)
                    .onChange(of: newTag) { change in
                        if change.isContainSpaceAndNewlines() {
                            appendNewTag()
                        }
                        withAnimation(Animation.easeOut(duration: 0).delay(1)) {
                            scrollView.scrollTo("TextField", anchor: .trailing)
                        }
                    }
                    .onChange(of: uploadData[selection].tags, perform: { _ in
                        newTag = ""
                        withAnimation(Animation.easeOut(duration: 0).delay(1)) {
                            scrollView.scrollTo("TextField", anchor: .trailing)
                        }
                    })
                    .fixedSize()
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .accentColor(Color.shootBlue)
                    .id("TextField")
                    .padding(.trailing)
                }
            }
        }
    }

    func appendNewTag() {
        var tag = newTag
        if !isBlank(tag: tag) {
            if tag.last == " " {
                tag.removeLast()
                if !isOverlap(tag: tag) {
                    withAnimation {
                        uploadData[selection].tags.append(tag)
                    }
                }
            } else {
                if !isOverlap(tag: tag) {
                    withAnimation {
                        uploadData[selection].tags.append(tag)
                    }
                }
            }
        }
        newTag = ""
    }

    func isOverlap(tag: String) -> Bool {
        if uploadData[selection].tags.contains(tag) {
            return true
        } else {
            return false
        }
    }

    func isBlank(tag: String) -> Bool {
        let tmp = tag.trimmingCharacters(in: .whitespaces)
        if tmp == "" {
            return true
        } else {
            return false
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UploadView(uploadData: .constant([])) {} shareDoneAction: {} uploadAction: {}
        }
        .previewDisplayName("Chinese")
        .environment(\.locale, .init(identifier: "zh-cn"))
        .environmentObject(InfoViewModel())
        .environmentObject(UserViewModel())

        NavigationView {
            UploadView(uploadData: .constant([])) {} shareDoneAction: {} uploadAction: {}
        }
        .previewDisplayName("English")
        .environment(\.locale, .init(identifier: "en"))
        .environmentObject(InfoViewModel())
        .environmentObject(UserViewModel())
    }
}
