//
//  DetailView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import SwiftUIFlowLayout
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
    @State var alertType: AlertToast.AlertType = .success(.black)
    @EnvironmentObject var user: UserViewModel
    @StateObject var detail: DetailViewModel = DetailViewModel()
    @State var showLogin = false
    #if os(iOS)
    @State var image: UIImage? = nil
    #else
    @State var image: NSImage? = nil
    #endif
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ImageView(urlString: shoot.compressedPicUrl, image: $image)
                .frame(maxWidth: 460)
                .padding(.top)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }.background(Color.shootLight.opacity(0.1))
            .onTapGesture {
                #if os(iOS)
                FeedbackManager.impact(style: .medium)
                #endif
                withAnimation(.spring()) {
                    if showSave {
                        withAnimation(.spring()) {
                            showSave = false
                        }
                    } else {
                        if detail.detail == nil {
                            Task {
                                await detail.getImageDetail(id: shoot.id) { success in
                                    withAnimation(.spring()) {
                                        showDetail = true
                                    }
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
            FullScreenSearchView(searchText: search)
        }
        #else
        .overlay(alignment: .topTrailing) {
            MacCloseButton()
                .padding(26)
        }
        #endif
        .toast(isPresenting: $showAlert) {
            AlertToast(displayMode: .alert, type: alertType, title: alertText)
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
                    Text(detail.detail?.linkApplicationName ?? "图片详情")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.shootBlack)
                    Image("link")
                }
            }.buttonStyle(.plain)
                .sheet(isPresented: $showApp) {
                    #if os(iOS)
                    NavigationView {
                        AppView(id: shoot.linkApplicationId ?? "")
                            .navigationTitle(detail.detail?.linkApplicationName ?? "图片详情")
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
                            Text(detail.detail?.linkApplicationName ?? "图片详情")
                                .font(.largeTitle)
                                .bold()
                            Spacer()
                            MacCloseButton()
                        }.padding([.horizontal, .top], 36)
                        AppView(id: shoot.linkApplicationId ?? "")
                    }.sheetFrameForMac()
                    #endif
                }

            // 个人信息
            HStack(spacing: 8) {
                Image(systemName: "person.2.crop.square.stack")
                    .font(.system(size: 30, weight: .regular))
                    .foregroundColor(.shootGray)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(detail.detail?.userName ?? "上传用户")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.shootBlack)
                    
                    HStack(spacing: 4) {
                        Image("upload")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        
                        Group {
                            Text("\(detail.detail?.uploadNum ?? "1")")
                            + Text(" 图片")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootBlack)
                        .padding(.trailing, 12)
                        Image("saved")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Group {
                            Text("\(detail.detail?.favoriteNum ?? "1")")
                            + Text(" 图片")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootBlack)
                    }
                }
                Spacer()
            }
            
            // 设计模式
            if let pattern = detail.detail {
                FlowLayout(mode: .vstack,
                           items: pattern.designPatternList,
                           itemSpacing: 4) { designPattern in
                    Button {
                        search = designPattern.designPatternName
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "number")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.shootBlue)
                            Text(designPattern.designPatternName)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.shootBlack)
                        }.padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.shootBlue.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }.buttonStyle(.plain)
                }
            }
            
            // 操作按钮
            HStack {
                ActionTitleButtonView(systemImage: "sparkles.rectangle.stack.fill", title: "系列") {
                    #if os(iOS)
                    FeedbackManager.impact(style: .medium)
                    #endif
                    if user.login {
                        withAnimation(.spring()) {
                            showDetail = false
                            showSave = true
                        }
                        Task {
                            await detail.getFavorites()
                        }
                    } else {
                        withAnimation(.spring()) {
                            showDetail = false
                            showLogin = true
                        }
                    }
                }
                Spacer(minLength: 0)
                if let image = image {
                    #if os(iOS)
                    ShareLink(item: Image(uiImage: image), preview: SharePreview("Shoots", image: Image(uiImage: image))) {
                        VStack {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text("分享")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.shootBlack)
                        }
                    }.buttonStyle(.plain)
                    #else
                    ShareLink(item: Image(nsImage: image), preview: SharePreview("Shoots", image: Image(nsImage: image))) {
                        VStack {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text("分享")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.shootBlack)
                        }
                    }.buttonStyle(.plain)
                    #endif
                    Spacer(minLength: 0)
                }
                
                ActionTitleButtonView(systemImage: "square.and.arrow.down.fill", title: "下载") {
                    if user.login {
                        #if os(iOS)
                        FeedbackManager.impact(style: .medium)
                        
                        let imageSaver = ImageSaver()
                        imageSaver.successHandler = {
                            alertText = "成功保存到相册"
                            alertType = .success(.black)
                            showAlert = true
                        }
                        imageSaver.errorHandler = {
                            print("保存失败: \($0.localizedDescription)")
                            alertText = "保存失败"
                            alertType = .error(.red)
                            showAlert = true
                        }
                        
                        guard let url = URL(string: shoot.picUrl) else { return }
                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data else { return }
                            imageSaver.writeToPhotoAlbum(image: UIImage(data: data)!)
                        }
                        task.resume()
                        
                        #else
                        if let url = showSavePanel() {
                            savePNG(imageName: "s1", path: url)
                        }
                        #endif
                    } else {
                        withAnimation(.spring()) {
                            showDetail = false
                            showLogin = true
                        }
                    }
                }
                Spacer(minLength: 0)
                ActionTitleButtonView(systemImage: "exclamationmark.shield.fill", title: "举报") {
                    showReport.toggle()
                }.sheet(isPresented: $showReport) {
                    ReportView(shoot: shoot) {
                        alertText = "反馈成功"
                        alertType = .success(.black)
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
            .background(Color.shootWhite)
            .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
            .shadow(color: Color.shootBlack.opacity(0.1), radius: 10, y: -6)
            .contentShape(Rectangle())
    }
    //sparkles.rectangle.stack
    //square.and.arrow.up.circle
    //square.and.arrow.down.fill
    //exclamationmark.shield
    @State var showSave = false
    @State var images = [["s7", "s2", "s4"], ["s5", "s2", "s4"]]
    var saveView: some View {
        VStack {
            ZStack {
                Text("添加到系列")
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
            
            if detail.favorites.isEmpty {
                VStack {
                    Image("empty")
                    Text("系列为空")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootGray)
                }.frame(height: 286)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 26) {
                        ForEach(detail.favorites) { favorite in
                            FolderCardView(images: favorite.pics, name: favorite.favoriteFileName, picCount: favorite.countPics)
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
                                    Task {
                                        await detail.savePics(pics: [shoot.id], favoriteFileId: favorite.id) { success in
                                            // 收藏成功
                                            showSave = false
                                            // 提示成功
                                            alertText = "添加成功"
                                            alertType = .success(.black)
                                            showAlert = true
                                        }
                                    }
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
        .background(Color.shootWhite)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.shootBlack.opacity(0.2), radius: 10, y: -10)
        .contentShape(Rectangle())
    }
    
    @State var name: String = ""
    @State var showNewFolder = false
    var newFoldereView: some View {
        VStack(spacing: 26) {
            Text("新建系列")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.shootBlack)
            
            VStack {
                TextField("输入系列名称", text: $name)
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
                        alertText = "系列名称不能为空！"
                        alertType = .error(.red)
                        showAlert = true
                    } else {
                        Task {
                            await detail.addFavorites(name: name) { success in
                                if success {
                                    withAnimation(.spring()) {
                                        showNewFolder = false
                                        name = ""
                                    }
                                    alertText = "创建成功"
                                    alertType = .success(.black)
                                    showAlert = true
                                }
                            }
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
            .background(Color.shootWhite)
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


