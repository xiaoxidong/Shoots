//
//  DetailView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import SwiftUIFlowLayout
import SDWebImageSwiftUI
#if os(iOS)
import Toast
#endif

struct DetailView: View {
    var shoot: Picture
    
    @State var showDetail = false
    @State var search: String? = nil
    @AppStorage("showDetailNew") var showDetailNew = true
    @State var showAlert = false
    @State var alertText = ""
    @EnvironmentObject var user: UserViewModel
    @State var detail: ImageDetailResponseData? = nil
    @State var showLogin = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            WebImage(url: URL(string: shoot.compressedPicUrl))
                // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                .placeholder(Image(systemName: "photo")) // Placeholder Image
                // Supports ViewBuilder as well
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFit()
                .frame(maxWidth: 460)
                .padding(.top)
                .frame(maxWidth: .infinity)
        }.background(Color.shootLight.opacity(0.1))
            .onTapGesture {
                withAnimation(.spring()) {
                    if showSave {
                        showSave = false
                    } else {
                        if detail == nil {
                            Task {
                                await user.getImageDetail(id: shoot.id) { detail in
                                    self.detail = detail
                                    showDetail = true
                                }
                            }
                        } else {
                            showDetail.toggle()
                        }
                    }
                }
            }
        .overlay(alignment: .bottom) {
            infoView
                .offset(y: showDetail ? 0 : 1000)
        }
        .overlay(alignment: .bottom) {
            saveView
                .offset(y: showSave ? 0 : 1000)
        }
        .overlay(
            Group {
                Color.black.opacity(showDetailNew ? 0.4 : 0)
                VStack(spacing: 16) {
                    Image("doubleclick")
                    Text("点击查看截图详情信息")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Button {
                        withAnimation(.spring()) {
                            showDetailNew.toggle()
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
                }.opacity(showDetailNew ? 1 : 0)
            }
        )
        .overlay(
            Group {
                Color.black
                    .ignoresSafeArea()
                    .opacity(showNewFolder ? 0.2 : 0)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showNewFolder = false
                        }
                    }
                if showNewFolder {
                    newFoldereView
                        .transition(.scale(scale: 0.6).combined(with: .opacity))
                }
            }
        )
        .overlay(
            LoginView(login: $showLogin) {
                
            }, alignment: .bottom
        )
        .ignoresSafeArea()
        #if os(iOS)
        .fullScreenCover(item: $search) { search in
            SearchView(searchText: search)
        }
        #else
        .overlay(alignment: .topTrailing) {
            MacCloseButton()
                .padding(26)
        }
        #endif
        .toast(isPresenting: $showAlert) {
            AlertToast(displayMode: .alert, type: .success(.black), title: alertText)
        }
    }
    
    
    @State var showApp = false
    @State var showReport = false
    @State var designTypes: [String] = []
    var infoView: some View {
        VStack(spacing: 16) {
            // 顶部应用按钮
            Button {
                showApp.toggle()
            } label: {
                HStack {
                    Text(detail?.linkApplicationName ?? "图片详情")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.shootBlack)
                    Image("link")
                }
            }.buttonStyle(.plain)
                .sheet(isPresented: $showApp) {
                    #if os(iOS)
                    NavigationView {
                        AppView(id: shoot.linkApplicationId ?? "")
                            .navigationTitle(detail?.linkApplicationName ?? "图片详情")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
//                                    ShareLink(item: URL(string: shoot.app.url)!) {
//                                        Image(systemName: "square.and.arrow.up.fill")
//                                    }.tint(.shootRed)
                                }
                            }
                    }
                    #else
                    VStack {
                        HStack {
                            Text("Instagram")
                                .font(.largeTitle)
                                .bold()
                            Spacer()
                            MacCloseButton()
                        }.padding([.horizontal, .top], 36)
//                        AppView(app: shoot.app)
                    }.sheetFrameForMac()
                    #endif
                }

            // 个人信息
            HStack {
                Image("s1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("shoot.author.name")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.shootBlack)
                    
                    HStack(spacing: 4) {
                        Image("upload")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        
                        Text(String(format: NSLocalizedString("%d 图片", comment: ""), 12))
                        // shoot.author.uploadCount
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                            .padding(.trailing, 12)
                        Image("saved")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text(String(format: NSLocalizedString("%d 图片", comment: ""), 12))
                        //shoot.author.uploadCount
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                    }
                }
                Spacer()
            }
            
            // 设计模式
            FlowLayout(mode: .vstack,
                       items: designTypes,
                       itemSpacing: 4) { text in
                Button {
                    search = text
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "number")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlue)
                        Text(text)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                    }.padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.shootBlue.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }.buttonStyle(.plain)
            }
            
            // 操作按钮
            HStack {
                ActionTitleButtonView(image: "save", title: "收藏") {
                    #if os(iOS)
                    FeedbackManager.impact(style: .medium)
                    #endif
                    if user.login {
                        withAnimation(.spring()) {
                            showDetail = false
                            showSave = true
                        }
                        Task {
                            await user.getFavorites()
                        }
                    } else {
                        showLogin.toggle()
                    }
                }
                Spacer(minLength: 0)
                
                ShareLink(item: Image(shoot.picUrl), preview: SharePreview("Shoots", image: Image(shoot.picUrl))) {
                    VStack {
                        Image("share")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("分享")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                    }
                }.buttonStyle(.plain)
                
                Spacer(minLength: 0)
                ActionTitleButtonView(image: "download", title: "下载") {
                    if user.login {
                        #if os(iOS)
                        FeedbackManager.impact(style: .medium)
                        
                        let imageSaver = ImageSaver()
                        imageSaver.successHandler = {
                            alertText = "成功保存到相册"
                            showAlert = true
                        }
                        imageSaver.errorHandler = {
                            print("保存失败: \($0.localizedDescription)")
                        }
                        //                    imageSaver.writeToPhotoAlbum(image: UIImage(named: shoot.imageUrl)!)
                        #else
                        if let url = showSavePanel() {
                            savePNG(imageName: "s1", path: url)
                        }
                        #endif
                    } else {
                        showLogin.toggle()
                    }
                }
                Spacer(minLength: 0)
                ActionTitleButtonView(image: "report", title: "举报") {
                    showReport.toggle()
                }.sheet(isPresented: $showReport) {
                    ReportView(shoot: shoot) {
                        alertText = "反馈成功"
                        showAlert = true
                    }
                        .sheetFrameForMac()
                }
            }.padding(.horizontal)
        }.frame(maxWidth: 460)
            .padding()
            .padding(.bottom)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.shootBlack.opacity(0.2), radius: 10, y: -10)
        .contentShape(Rectangle())
    }
    
    @State var showSave = false
    @State var images = [["s7", "s2", "s4"], ["s5", "s2", "s4"]]
    var saveView: some View {
        VStack {
            ZStack {
                Text("添加收藏夹")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.shootBlack)
                Button {
                    withAnimation(.spring()) {
                        showNewFolder = true
                    }
                } label: {
                    Image("add")
                }.padding(.trailing)
                    .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            if user.favorites.isEmpty {
                Text("收藏夹为空")
                    .frame(height: 286)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 26) {
                        ForEach(user.favorites) { favorite in
                            FolderCardView(images: favorite.pics, name: favorite.favoriteFileName)
                                .frame(minWidth: 156)
                                .overlay(
                                    Group {
                                        if favorite.pics.isEmpty {
                                            Image(systemName: "plus")
                                        }
                                    }
                                )
                                .onTapGesture {
                                    // 收藏

                                    #if os(iOS)
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                        // 收藏成功
                                        showSave = false
                                        // 提示成功
                                        alertText = "收藏成功"
                                        showAlert = true
                                    }
                                    #endif
                                }
                        }
                    }.padding(.horizontal, 26)
                }
            }
        }
            .padding(.vertical)
            .padding(.bottom)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.shootBlack.opacity(0.2), radius: 10, y: -10)
        .contentShape(Rectangle())
    }
    
    @State var name: String = ""
    @State var showNewFolder = false
    var newFoldereView: some View {
        VStack(spacing: 26) {
            Text("新建收藏夹")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.shootBlack)
            
            VStack {
                TextField("输入收藏夹名称", text: $name)
                    .textFieldStyle(.plain)
                    .padding(.horizontal)
                Divider()
            }
            
            HStack(spacing: 56) {
                Button {
                    withAnimation(.spring()) {
                        showNewFolder = false
                    }
                } label: {
                    Text("取消")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                        .background(Color.shootLight.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }.buttonStyle(.plain)
                Button {
                    if name == "" {
                        alertText = "收藏夹名称不能为空！"
                        showAlert = true
                    } else {
                        Task {
                            await user.addFavorites(name: name)
                        }
                        
                        withAnimation(.spring()) {
                            showNewFolder = false
                        }
                    }
                } label: {
                    Text("确认")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Color.shootRed)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }.buttonStyle(.plain)
            }
        }.padding()
            .padding(.vertical)
            .frame(maxWidth: 460)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding()
    }
    
    #if os(macOS)
    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png, .jpeg]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "保存图片"
        savePanel.message = "选择保存位置"
        savePanel.nameFieldLabel = "名称："
        
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
    
    func savePNG(imageName: String, path: URL) {
        let image = NSImage(named: imageName)!
        let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
        let pngData = imageRepresentation?.representation(using: .png, properties: [:])
        do {
            try pngData!.write(to: path)
        } catch {
            print(error)
        }
    }
    #endif
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(shoot: singleShoot)
//            .previewDisplayName("Chinese")
//            .environment(\.locale, .init(identifier: "zh-cn"))
//        DetailView(shoot: singleShoot)
//            .previewDisplayName("English")
//            .environment(\.locale, .init(identifier: "en"))
//    }
//}


