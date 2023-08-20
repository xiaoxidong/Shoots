//
//  ContentView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/14.
//

import Photos
import SwiftUI

// 预览模式下无法选择相册上传图片，请在模拟器里查看上传操作。
struct ContentView: View {
    @State var searchText: String = ""

    @AppStorage("showHomeNew") var showHomeNew: Int = 0
    @AppStorage("showCustomUpload") var showCustomUpload = true
    @State var uploadOptions = false
    @State var showLogin = false
    @State var customUpload = false
    @State var upload = false
    @State var showNavigation = true
    @State var showToast = false
    @State var toastText = ""
    @State var alertType: AlertToast.AlertType = .success(Color.shootBlack)
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var selectedImages: [UIImage] = []
    @State var selectedAssets: [PHAsset] = []
    @State var uploadData: [LocalImageData] = []
    @State var showUploadAction = false
    @AppStorage("askToDelete") var askToDelete: Bool = true
    @AppStorage("deletePicsUploaded") var deletePicsUploaded: Bool = false
    @State var showAsk = false
    @State var showAudit = false
    #endif
    var body: some View {
        NavigationView {
            #if os(iOS)
                if horizontalSizeClass == .compact {
                    iOSHomeView
                        .overlay(
                            Button(action: {
                                FeedbackManager.impact(style: .soft)
                                showAudit.toggle()
                            }, label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 36))
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }).padding()
                            , alignment: .bottomTrailing
                        )
                } else {
                    iPadHomeView
                }
            #else
                iPadHomeView
            #endif
        }
        .overlay {
            homeNew
        }
        .overlay(alignment: .top) {
            Color.black
                .frame(height: 200)
                .opacity(uploadOptions ? 0.01 : 0)
                .onTapGesture {
                    withAnimation(.spring()) {
                        uploadOptions = false
                        uploadisActive = false
                    }
                }
        }
        #if os(iOS)
        .overlay(uploadingView, alignment: .bottom)
        .fullScreenCover(isPresented: $customUpload, content: {
            CustomUploadView()
        })
        .overlay {
            Color.black.opacity(uploadisActive || showAsk ? 0.16 : 0)
                .animation(.spring(), value: uploadisActive || showAsk)
                .ignoresSafeArea()
        }
        .overlay {
            Group {
                if showAsk {
                    askToDeleteView
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
        }
        .fullScreenCover(isPresented: $uploadisActive, onDismiss: {
            withAnimation(.spring()) {
                uploadisActive = false
            }

            if !selectedImages.isEmpty {
                Task {
                    selectedImages.forEach { image in
                        uploadData.append(LocalImageData(image: image.pngData()!, app: "", fileName: "", fileSuffix: ""))
                    }
                    upload.toggle()
                }
            }
        }, content: {
            SelectPhotoView(show: $uploadisActive, selectedImages: $selectedImages, selectedAssets: $selectedAssets)
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

                                // 询问是否删除截图，并且记录选择结果
                                if askToDelete {
                                    withAnimation(.spring()) {
                                        showAsk = true
                                    }
                                } else if deletePicsUploaded {
                                    deleteUploadedImages()
                                }
                            } else {}
                        }
                    }
                }
            }
        })
        .sheet(isPresented: $user.editInfo) {
            if #available(iOS 16.0, *) {
                InfoView {
                    toastText = "更新成功"
                    showToast = true
                }
                .presentationDetents([.medium])
                .interactiveDismissDisabled()
            } else {
                InfoView {
                    toastText = "更新成功"
                    showToast = true
                }
            }
        }
        .fullScreenCover(isPresented: $showAudit) {
            AuditView()
        }
        #else
        .sheet(isPresented: $user.editInfo) {
            InfoView {
                toastText = "更新成功"
                showToast = true
            }.frame(width: 400, height: 400)
        }
        #endif
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: alertType, title: toastText)
        }
        .onAppear {
            // DEBUG 模式下显示自定义上传
            #if DEBUG
            showCustomUpload = true
            #endif
            // 如果自定义上传上传过，则不显示
            // 如果上传了 x 次，但是还是没有使用自定义上传，也不需要显示
            
            if showHomeNew < 4 {
                showHomeNew += 1
            }
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

    #if os(iOS)
    @ViewBuilder
    var iOSHomeView: some View {
        if #available(iOS 16.0, *) {
            homeFeed
                .navigationTitle("Shoots")
                .toolbar(showNavigation ? .visible : .hidden, for: .automatic)
                .animation(.easeIn(duration: 0.3), value: showNavigation)
        } else {
            homeFeed
                .navigationTitle("Shoots")
        }
    }
    
    var askToDeleteView: some View {
        VStack(spacing: 26) {
            Text("删除已上传截图")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.shootBlack)
            
            VStack(spacing: 16) {
                Text("上传完成之后，删除截图相册内的截图？")
                    .font(.system(size: 16, weight: .medium))
                    .lineSpacing(4)
                
                Toggle(isOn: $deletePicsUploaded, label: {
                    Text("每次都删除")
                }).toggleStyle(CheckToggleStyle())
                    .onChange(of: deletePicsUploaded, perform: { newValue in
                        if newValue {
                            askToDelete = false
                        }
                    })
            }.font(.system(size: 15, weight: .medium))
                .foregroundColor(.shootGray)
            
            HStack(spacing: 56) {
                Button {
                    withAnimation(.spring()) {
                        showAsk = false
                        askToDelete = false
                        deletePicsUploaded = false
                    }
                } label: {
                    Text("不在询问")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                        .background(Color.shootBlack.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                }.buttonStyle(.plain)
                Button {
                    withAnimation(.spring()) {
                        showAsk = false
                        deleteUploadedImages()
                    }
                } label: {
                    Text("删除")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Color.shootRed)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                }.buttonStyle(.plain)
            }
        }.padding()
            .padding(.vertical, 16)
            .frame(maxWidth: 460)
            .background(Color.shootWhite)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .padding()
    }
    
    func deleteUploadedImages() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(selectedAssets as NSFastEnumeration)
        }, completionHandler: { success, error in
            print(success ? "Success" : error)
            if success {
                toastText = "删除成功"
                showToast = true
            }
        })
    }
    #endif

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
                            if let avatar = user.avatar {
                                ImageView(urlString: avatar, image: .constant(nil))
                                    .frame(width: 26, height: 26)
                                    .clipShape(Circle())
                            } else {
                                Image("self")
                                    .renderingMode(.template)
                                    .foregroundColor(.shootBlack)
                                    .padding(.vertical, 6)
                                    .padding(.trailing, 6)
                                    .contentShape(Rectangle())
                                    .clipShape(Circle())
                            }
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
                    if false {
                        Button {
                            FeedbackManager.impact(style: .soft)
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
                    } else {
                        Menu {
                            Button {
                                FeedbackManager.impact(style: .soft)
                                uploadisActive.toggle()
                            } label: {
                                Label("上传截图 ", image: "upload")
                            }
                            
                            Button {
                                FeedbackManager.impact(style: .soft)
                                customUpload.toggle()
                            } label: {
                                Label("交互设计", image: "tags")
                            }
                        } label: {
                            Image("upload")
                                .padding(.vertical, 6)
                                .padding(.leading, 6)
                                .contentShape(Rectangle())
                        }
                    }
                    /*
                    if showCustomUpload {
                        if horizontalSizeClass == .compact {
                            Button {
                                FeedbackManager.impact(style: .soft)
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
                                    FeedbackManager.impact(style: .soft)
                                    uploadisActive.toggle()
                                } label: {
                                    Label("上传截图", image: "upload")
                                }
                                
                                Button {
                                    FeedbackManager.impact(style: .soft)
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
                            FeedbackManager.impact(style: .soft)
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
                        if let avatar = user.avatar {
                            ImageView(urlString: avatar, image: .constant(nil))
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                        } else {
                            Image("self")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(.shootBlack)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .clipShape(Circle())
                        }
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
            .overlay(alignment: .bottom) {
                Group {
                    if !user.login {
                        LoginView(login: .constant(true), showBG: false, successAction: {
                            toastText = "登录成功"
                            showToast = true
                        }, failAction: {
                            toastText = "登录失败，请重试"
                            showToast = true
                        })
                        .offset(y: showNavigation ? 0 : 1000)
                        .animation(.easeIn(duration: 1), value: showNavigation)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                uploadView
            }
        #else
            .searchable(text: $searchText, placement: .toolbar, prompt: "搜索应用或设计模式")
        //        {
        //                    SearchSuggestionView(searchText: $searchText)
        //                        .frame(maxHeight: 560)
        //                }
            .onSubmit(of: .search) {
                search.search(text: searchText)
            }
            .overlay(alignment: .bottom) {
                Group {
                    if showLogin {
                        LoginView(login: $showLogin, showBG: true, successAction: {
                            toastText = "登录成功"
                            showToast = true
                        }, failAction: {
                            toastText = "登录失败，请重试"
                            showToast = true
                        })
                    }
                }
            }
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
            Color.black.opacity(showHomeNew == 3 ? 0.4 : 0)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Image("doubleclick")
                Text("双击切换查看其他试图")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Button {
                    withAnimation(.spring()) {
                        showHomeNew = 10
                    }
                } label: {
                    Text("知道了")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 56)
                        .padding(.vertical, 12)
                        .background(LinearGradient(colors: [.pink, .yellow], startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                }.buttonStyle(.plain)
                .padding(.top)
            }.opacity(showHomeNew == 3 ? 1 : 0)
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
