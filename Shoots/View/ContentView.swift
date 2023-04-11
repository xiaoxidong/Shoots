//
//  ContentView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/14.
//

import SwiftUI

// 预览模式下无法选择相册上传图片，请在模拟器里查看上传操作。
struct ContentView: View {
    @StateObject var homeVM: HomeViewModel = HomeViewModel()
    @State var searchText: String = ""
    
    @AppStorage("showHomeNew") var showHomeNew = true
    @AppStorage("showCustomUpload") var showCustomUpload = true
    @State var uploadOptions = false
    @State var customUpload = false
    @State var upload = false
    @State var showNavigation = true
    @State var offset: CGSize = .zero

    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var selectedImages: [UIImage] = []
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
                        uploadOptions.toggle()
                    }
                }
            , alignment: .top
        )
        .ignoresSafeArea()
        #if os(iOS)
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
                upload.toggle()
            }
        }, content: {
            SelectPhotoView(show: $uploadisActive, selectedImages: $selectedImages)
                .background(BackgroundClearView())
                .ignoresSafeArea()
        })
        .fullScreenCover(isPresented: $upload, onDismiss: {
            selectedImages.removeAll()
        }, content: {
            UploadView(uploadImages: selectedImages)
        })
        #endif
        .onAppear {
            // 请求第一页的数据
            loadData()
            
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
                .frame(minWidth: 280)
            #endif

            homeFeed
        }
    }
    
    var iOSHomeView: some View {
        homeFeed
            .navigationTitle("Shoots")
            .simultaneousGesture(
                DragGesture()
                    .onChanged({ location in
                        offset = location.translation
                        if location.translation.height > 0 {
                            print("下")
                            withAnimation(.spring()) {
                                showNavigation = true
                            }
                        } else {
                            print("上")
                            withAnimation(.spring()) {
                                showNavigation = false
                            }
                        }
                    })
            )
            .toolbar(showNavigation ? .visible : .hidden, for: .automatic)
    }
    
    @State var uploadisActive = false
    @State var showMacSelf = false
    @State var showMacPro = false
    var homeFeed: some View {
        HomeView(homeVM: homeVM, searchText: $searchText)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        SelfView()
                    } label: {
                        Image("pic")//"self"
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showCustomUpload {
                        if horizontalSizeClass == .compact {
                            Button {
                                FeedbackManager.impact(style: .medium)
                                withAnimation(.spring()) {
                                    uploadOptions.toggle()
                                }
                            } label: {
                                Image("upload")
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
                        }
                    }
                }
                #else
                ToolbarItem(placement: .navigation) {
                    Button {
                        showMacSelf.toggle()
                    } label: {
                        // 登录和未登录状态设置
                        if true {
                            Image("pic")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                        } else {
                            Image("self")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .padding(3)
                        }
                    }
                }
                #endif
            }
        #if os(iOS)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            .overlay(
                uploadView, alignment: .bottom
            )
        #else
            .searchable(text: $searchText)
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
                            .font(.system(size: 14, weight:  .medium))
                            .foregroundColor(.shootLight)
                    }
                }.frame(maxWidth: .infinity)
                    .padding()
                    .padding(.bottom)
                    .padding(.top, 8)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.shootBlack.opacity(0.2), radius: 10, y: -10)
                .contentShape(Rectangle())
                .offset(y: uploadOptions ? 0 : 1000)
            }.frame(maxWidth: 660)
        }
    }
    #endif
    
    var homeNew: some View {
        Group {
            Color.black.opacity(showHomeNew ? 0.4 : 0)
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
    // MARK: - 首页方法
    func loadData() {
        homeVM.getData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
