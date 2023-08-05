//
//  UploadView.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/8/5.
//

import SwiftUI

struct UploadView: View {
    let shareCancellAction: () -> Void
    let shareDoneAction: () -> Void
    let uploadAction: () -> Void

    @State var uploadData: [LocalImageData] = []
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
                    .frame(width: screen.width)
                    .ignoresSafeArea()
                    .tag(indice)
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                appFocused = false
                tagFocused = false
            }
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
                        .padding(.bottom)
                }
            }
            .toast(isPresenting: $showToast) {
                AlertToast(displayMode: .alert, type: alertType, title: toastText)
            }
            .onChange(of: selection, perform: { _ in
                if uploadData[selection].app == "" {
                    appFocused = true
                } else if uploadData[selection].pattern == "" {
                    tagFocused = true
                }
            })
            .onAppear {
                #if DEBUG
                    showBlurNewGuide = true
                #endif

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let data = Defaults().get(for: .shareImage) {
                        uploadData = [data]
                    } else {}
                }
            }
    }

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
                if uploadData.count < 2 {
                    Text("上传图片")
                        .font(.system(size: 14, weight: .medium))
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
                        appFocused = false
                        tagFocused = false
                        toastText = "请先打开应用登录"
                        showToast = true
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
        }.padding(.top, 16)
    }

    @State var showBluer = false
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

    @FocusState var appFocused: Bool
    @FocusState var tagFocused: Bool

    var bottomActions: some View {
        VStack(spacing: 0) {
            if appFocused {
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
                                appFocused = false
                                tagFocused = true
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
                    .shadow(color: Color.shootBlack.opacity(tagFocused ? 0.06 : 0), x: 0, y: -6, blur: 10)
            }
            VStack(spacing: 6) {
                Divider()
                HStack(spacing: 8) {
                    TextField("应用名称", text: $uploadData[selection].app)
                        .focused($appFocused)
                        .font(.system(size: 14, weight: .medium))
                        .accentColor(Color.shootBlue)
                        .frame(width: 106)

                    Divider()
                        .frame(height: 36)
                    tag
                        .font(.system(size: 14, weight: .medium))
//                    Button {
//                        showBluer.toggle()
//                    } label: {
//                        Image("blur")
//                            .padding(4)
//                            .contentShape(Rectangle())
//                    }

                    Button {
                        showCombine.toggle()
                    } label: {
                        Image("connect")
                            .padding(4)
                            .contentShape(Rectangle())
                    }
                }.padding(.horizontal, 8).padding(.bottom, 6)
            }
            .background(Color.shootWhite)
            .shadow(color: Color.shootBlack.opacity(appFocused || tagFocused ? 0 : 0.06), x: 0, y: -6, blur: 10)
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
            appFocused = true
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
            // 上传截图
            Task {
                user.uploadImages(localDatas: uploadData) { pics in
                    user.uploadPics(pics: pics) { success in
                        if success {
                            uploadData.removeAll()
                            // 完成之后关闭
                            shareDoneAction()
                        } else {
                            alertType = .error(.red)
                            toastText = "上传失败，请重试"
                            showToast = true
                        }
                    }
                }
            }
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
                        tagFocused = true
                        appendNewTag()

                        // TODO: 输入完成的时候，不隐藏键盘
                        // https://stackoverflow.com/questions/69225415/swiftui-stay-on-same-textfield-after-on-commit
                        // https://github.com/mobilinked/MbSwiftUIFirstResponder
                    })
                    .focused($tagFocused)
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
            UploadView {} shareDoneAction: {} uploadAction: {}
        }
        .previewDisplayName("Chinese")
        .environment(\.locale, .init(identifier: "zh-cn"))
        .environmentObject(InfoViewModel())
        .environmentObject(UserViewModel())

        NavigationView {
            UploadView {} shareDoneAction: {} uploadAction: {}
        }
        .previewDisplayName("English")
        .environment(\.locale, .init(identifier: "en"))
        .environmentObject(InfoViewModel())
        .environmentObject(UserViewModel())
    }
}
