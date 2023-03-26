//
//  UploadView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

struct UploadView: View {
    @State var selection: Int = 0
    @Environment(\.dismiss) var dismiss
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    var body: some View {
        TabView(selection: $selection) {
            Image("s1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screen.width, height: screen.height)
                .ignoresSafeArea()
                .tag(0)
            Image("s2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screen.width, height: screen.height)
                
                .tag(1)
            Image("s3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screen.width, height: screen.height)
                .ignoresSafeArea()
                .tag(2)
            Image("s4")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screen.width, height: screen.height)
                .ignoresSafeArea()
                .tag(3)
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                appFocused = false
                tagFocused = false
            }
        .edgesIgnoringSafeArea(.all)
        .safeAreaInset(edge: .top) {
            if horizontalSizeClass == .compact {
                topActions
                    .background(Color.white)
            } else {
                topActions
                    .padding(.top)
                    .background(Color.white)
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomActions
        }
    }
    
    var topActions: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.shootBlack)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
                TitlePageControll(progress: selection, numberOfPages: 4, tintColor: UIColor(Color.shootLight), currentPageTintColor: UIColor(Color.shootBlue))
                    .frame(height: 24)
                Spacer(minLength: 0)
                Button {
                    dismiss()
                    //TODO: 后台上传截图
                    
                } label: {
                    Text("上传")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.shootBlue)
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.padding(.horizontal)
            Divider()
        }
    }
    
    @State var appText = ""
    @State var tagText = ""
    @State var showBluer = false
    @State var showCombine = false
    @State var appTexts: [String] = ["Instagram", "Facebook", "Paper", "微博", "知乎", "Twitter", "抖音"]
    var appRsults: [String] {
        if appText == "" {
            return appTexts
        } else {
            return appTexts.filter({ $0.transToLowercasedPinYin().contains(appText.transToLowercasedPinYin()) })
        }
    }
    var tagRsults: [String] {
        if tagText.components(separatedBy: ",").last == "" {
            return tagTexts
        } else {
            return tagTexts.filter({ $0.transToLowercasedPinYin().contains(tagText.components(separatedBy: ",").last?.transToLowercasedPinYin() ?? "") })
        }
    }
    @State var tagTexts: [String] = ["设置", "粉丝", "信息流", "自定义内容", "卡片", "用户中心", "推荐", "Setting"]
    @FocusState var appFocused: Bool
    @FocusState var tagFocused: Bool
    var bottomActions: some View {
        VStack(spacing: 0) {
            if appFocused {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(appRsults, id: \.self) { app in
                            Button {
                                appText = app
                                appFocused = false
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(app)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.shootBlack)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 16)
                                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                    Divider()
                                }.frame(width: .infinity, alignment: .leading)
                                    .background(Color.white)
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
                                if tagText == "" {
                                    tagText = "\(tag),"
                                } else if !tagText.contains(tag) {
                                    var new = tagText.components(separatedBy: ",")
                                    new.removeLast()
                                    tagText = new.joined(separator: ",") + ",\(tag),"
                                }
                            } label: {
                                VStack(alignment: .center, spacing: 0) {
                                    Text(tag)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.shootBlack)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 16)
                                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                    Divider()
                                }.frame(width: .infinity, alignment: .center)
                                    .background(Color.white)
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
                    TextField("应用名称", text: $appText)
                        .focused($appFocused)
                    Divider()
                        .frame(height: 36)
                    TextField("设计模式", text: $tagText)
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
                    } label: {
                        Image("connect")
                            .padding(4)
                            .contentShape(Rectangle())
                    }
                }.padding(.horizontal)
            }
                .background(Color.white)
                .shadow(color: Color.shootBlack.opacity(appFocused || tagFocused ? 0 : 0.06), x: 0, y: -6, blur: 10)
                
        }
            .fullScreenCover(isPresented: $showBluer) {
                ShootBlurView()
            }
            .fullScreenCover(isPresented: $showCombine) {
                CombineSelectView()
            }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UploadView()
        }
    }
}