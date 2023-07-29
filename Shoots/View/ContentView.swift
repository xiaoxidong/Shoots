//
//  ContentView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/14.
//

import SwiftUI

// 预览模式下无法选择相册上传图片，请在模拟器里查看上传操作。
struct ContentView: View {
    @State var searchText: String = ""

    @AppStorage("showHomeNew") var showHomeNew = true
    @AppStorage("showCustomUpload") var showCustomUpload = true
    @State var uploadOptions = false
    @State var showLogin = false
    @State var customUpload = false
    @State var upload = false
    @State var showNavigation = true

    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        @Environment(\.verticalSizeClass) var verticalSizeClass
        @State var selectedImages: [UIImage] = []
        @State var uploadData: [LocalImageData] = []
        @State var showUploadAction = false
        @State var showToast = false
        @State var toastText = ""
        @State var alertType: AlertToast.AlertType = .success(Color.shootBlack)
    #endif
    var body: some View {
        NavigationView {
            #if os(iOS)
                if horizontalSizeClass == .compact {
                    iOSHomeView
                } else {
                    iPadHomeView
                }
            #else
                iPadHomeView
            #endif
        }
        .overlay(
            homeNew
        )
        .overlay(
            Color.black
                .frame(height: 200)
                .opacity(uploadOptions ? 0.01 : 0)
                .onTapGesture {
                    withAnimation(.spring()) {
                        uploadOptions = false
                        uploadisActive = false
                    }
                },
            alignment: .top
        )
        #if os(iOS)
        .overlay(uploadingView, alignment: .bottom)
        .fullScreenCover(isPresented: $customUpload, content: {
            CustomUploadView()
        })
        .overlay {
            Color.black.opacity(uploadisActive ? 0.16 : 0)
                .animation(.spring(), value: uploadisActive)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $uploadisActive, onDismiss: {
            withAnimation(.spring()) {
                uploadisActive = false
            }

            if !selectedImages.isEmpty {
                Task {
                    selectedImages.forEach { image in
                        uploadData.append(LocalImageData(image: image.pngData()!, app: "", pattern: "", fileName: "", fileSuffix: ""))
                    }
                    upload.toggle()
                }
            }
        }, content: {
            SelectPhotoView(show: $uploadisActive, selectedImages: $selectedImages)
                .background(BackgroundClearView())
                .ignoresSafeArea()

        })
        .fullScreenCover(isPresented: $upload, onDismiss: {
            selectedImages.removeAll()
            uploadData.removeAll()
        }, content: {
            UploadView(uploadData: $uploadData) {} shareDoneAction: {} uploadAction: {
                showUploadAction = true

                Task {
                    user.uploadImages(localDatas: uploadData) { pics in
                        user.uploadPics(pics: pics) { success in
                            if success {
                                uploadData.removeAll()
                                toastText = "上传成功"
                                showToast = true
                            } else {}
                        }
                    }
                }
            }
        })
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: alertType, title: toastText)
        }
        #endif
        .onAppear {
            // DEBUG 模式下显示自定义上传
            #if DEBUG
                showCustomUpload = true
            #endif
            // 如果自定义上传上传过，则不显示
            // 如果上传了 x 次，但是还是没有使用自定义上传，也不需要显示
        }
    }

    var iPadHomeView: some View {
        Group {
            IPadSearchDefaultView(searchText: $searchText)
            #if os(iOS)
                .navigationTitle("Shoots")
            #else
                .frame(minWidth: 300)
            #endif
            homeFeed
        }
    }

    var iOSHomeView: some View {
        homeFeed
            .navigationTitle("Shoots")
            .toolbar(showNavigation ? .visible : .hidden, for: .automatic)
    }

    @State var uploadisActive = false
    @State var showMacSelf = false
    @State var showMacPro = false
    @EnvironmentObject var user: UserViewModel
    @EnvironmentObject var search: SearchViewModel
    var homeFeed: some View {
        HomeView(searchText: $searchText, showNavigation: $showNavigation)
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .navigationBarLeading) {
                        if user.login {
                            NavigationLink {
                                SelfView()
                            } label: {
                                Image("self")
                                    .renderingMode(.template)
                                    .foregroundColor(.shootBlack)
                                    .padding(.vertical, 6)
                                    .padding(.trailing, 6)
                                    .contentShape(Rectangle())
                                    .clipShape(Circle())
                            }
                        } else {
                            NavigationLink {
                                SettingView()
                            } label: {
                                Image("setting")
                                    .renderingMode(.template)
                                    .foregroundColor(.shootBlue)
                                    .padding(.vertical, 6)
                                    .padding(.trailing, 6)
                                    .contentShape(Rectangle())
                            }
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            FeedbackManager.impact(style: .medium)
                            withAnimation(.spring()) {
                                uploadisActive = true
                            }
                            /*
                             if showCustomUpload {
                                 withAnimation(.spring()) {
                                     uploadOptions.toggle()
                                 }
                             } else {
                                 withAnimation(.spring()) {
                                     uploadisActive = true
                                 }
                             }
                              */
                        } label: {
                            Image("upload")
                                .padding(.vertical, 6)
                                .padding(.leading, 6)
                                .contentShape(Rectangle())
                        }
                        /*
                         if showCustomUpload {
                             if horizontalSizeClass == .compact {
                                 Button {
                                     FeedbackManager.impact(style: .medium)
                                     withAnimation(.spring()) {
                                         uploadOptions.toggle()
                                     }
                                 } label: {
                                     Image("upload")
                                         .padding(.vertical, 6)
                                         .padding(.leading, 6)
                                         .contentShape(Rectangle())
                                 }
                             } else {
                                 Menu {
                                     Button {
                                         FeedbackManager.impact(style: .medium)
                                         uploadisActive.toggle()
                                     } label: {
                                         Label("上传截图", image: "upload")
                                     }

                                     Button {
                                         FeedbackManager.impact(style: .medium)
                                         customUpload.toggle()
                                     } label: {
                                         Label("整理截图", image: "tags")
                                     }
                                 } label: {
                                     Image("upload")
                                         .padding(.vertical, 6)
                                         .padding(.leading, 6)
                                         .contentShape(Rectangle())
                                 }
                             }
                         } else {
                             Button {
                                 FeedbackManager.impact(style: .medium)
                                 if showCustomUpload {
                                     withAnimation(.spring()) {
                                         uploadOptions.toggle()
                                     }
                                 } else {
                                     withAnimation(.spring()) {
                                         uploadisActive = true
                                     }
                                 }
                             } label: {
                                 Image("upload")
                                     .padding(.vertical, 6)
                                     .padding(.leading, 6)
                                     .contentShape(Rectangle())
                             }
                         }
                         */
                    }
                #else
                    ToolbarItem(placement: .navigation) {
                        Button {
                            if user.login {
                                showMacSelf.toggle()
                            } else {
                                withAnimation(.spring()) {
                                    showLogin.toggle()
                                }
                            }
                        } label: {
                            // 登录和未登录状态设置
                            Image("self")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(.shootBlack)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .clipShape(Circle())
                        }
                    }
                #endif
            }
        #if os(iOS)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索应用或设计模式")
            .onSubmit(of: .search) {
                search.search(text: searchText)
                self.resignFirstResponder()
            }
            .overlay(
                Group {
                    if !user.login {
                        LoginView(login: .constant(true), showBG: false) {}
                    }
                },
                alignment: .bottom
            )
            .overlay(
                uploadView, alignment: .bottom
            )
        #else
            .searchable(text: $searchText, placement: .toolbar, prompt: "搜索应用或设计模式")
//        {
//                    SearchSuggestionView(searchText: $searchText)
//                        .frame(maxHeight: 560)
//                }
                .onSubmit(of: .search) {
                    search.search(text: searchText)
                }
                .overlay(
                    Group {
                        if showLogin {
                            LoginView(login: $showLogin, showBG: true) {}
                        }
                    },
                    alignment: .bottom
                )
                .sheet(isPresented: $showMacSelf) {
                    SelfView().sheetFrameForMac()
                }
                .sheet(isPresented: $showMacPro) {
                    ProView().sheetFrameForMac()
                }
        #endif
                .edgesIgnoringSafeArea(.bottom)
    }

    #if os(iOS)
        var uploadView: some View {
            Group {
                Color.black.opacity(uploadOptions ? 0.02 : 0)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            uploadOptions.toggle()
                        }
                    }
                VStack {
                    Spacer()
                    VStack(spacing: 22) {
                        Text("选择操作")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.shootBlack)
                        Button(action: {
                            withAnimation(.spring()) {
                                uploadOptions.toggle()
                                uploadisActive = true
                            }
                        }, label: {
                            HStack {
                                Image("uploadwhite")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .frame(width: 22, height: 22)
                                Text("上传截图")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }.frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(LinearGradient(colors: [.yellow, .pink], startPoint: .leading, endPoint: .trailing))
                                .clipShape(Capsule())
                        })

                        VStack(spacing: 8) {
                            Button {
                                customUpload.toggle()
                            } label: {
                                HStack {
                                    Image("tags")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 22, height: 22)
                                    Text("整理截图")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }.frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.shootYellow)
                                    .clipShape(Capsule())
                            }
                            Text("一次性快速整理之前截图")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.shootLight)
                        }
                    }.frame(maxWidth: .infinity)
                        .padding()
                        .padding(.bottom)
                        .padding(.top, 8)
                        .background(Color.shootWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                        .shadow(color: Color.shootBlack.opacity(0.1), radius: 10, y: -6)
                        .contentShape(Rectangle())
                        .offset(y: uploadOptions ? 0 : 1000)
                }.frame(maxWidth: 660)
            }
        }

        @ViewBuilder
        var uploadingView: some View {
            if user.uploading {
                VStack(spacing: 12) {
                    if !user.error {
                        HStack(spacing: 12) {
                            Text("上传图片")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.shootBlack)
                            ProgressView()
                        }

                    } else {
                        HStack(spacing: 12) {
                            Text("上传失败")
                                .foregroundColor(.shootBlack)
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                            Spacer()

                            Button(action: {}, label: {
                                Text("重新上传")
                            })
                        }.font(.system(size: 16, weight: .bold))
                    }
                    ProgressView(value: CGFloat(user.uploadIndex), total: CGFloat(uploadData.count + 1), label: {}, currentValueLabel: {
                        Text("正在上传")
                    }).progressViewStyle(.linear)
                }
                .padding()
                .padding(.bottom)
                .padding(.top, 8)
                .background(Color.shootWhite)
                .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                .shadow(color: Color.shootBlack.opacity(0.1), radius: 10, y: -6)
                .contentShape(Rectangle())
                .padding(.horizontal)
                .frame(maxWidth: 660)
            }
        }
    #endif

    var homeNew: some View {
        Group {
            Color.black.opacity(showHomeNew ? 0.4 : 0)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Image("doubleclick")
                Text("双击切换查看其他试图")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Button {
                    withAnimation(.spring()) {
                        showHomeNew.toggle()
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
            }.opacity(showHomeNew ? 1 : 0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let user = UserViewModel()

    static var previews: some View {
        ContentView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
            .environmentObject(user)
            .environmentObject(InfoViewModel())
        ContentView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(user)
            .environmentObject(InfoViewModel())
    }
}
