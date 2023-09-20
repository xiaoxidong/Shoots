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
    @State var shoots: [Picture]

    @State var selection: Int = 0
    @State var showDetail = false
    @State var searchText: String? = nil
    @AppStorage("showDetailNew") var showDetailNew = true
    @AppStorage("dayFree") var dayFree: Int = 0
    @State var showAlert = false
    @State var alertText = ""
    @State var alertType: AlertToast.AlertType = .success(Color.shootBlack)
    @EnvironmentObject var user: UserViewModel
    @StateObject var detail: DetailViewModel = .init()
    @State var showLogin = false
    #if os(iOS)
    @State var image: UIImage? = nil
    #else
    @State var image: NSImage? = nil
    #endif
    @EnvironmentObject var search: SearchViewModel
    var body: some View {
        content
            .overlay(alignment: .bottom) {
                infoView
                    .offset(y: showDetail ? 0 : 100)
                    .opacity(showDetail ? 1 : 0)
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
                        }.buttonStyle(.plain)
                            .padding(.top)
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
                            .transition(.scale(scale: 0.9).combined(with: .opacity))
                    }
                }
            )
            .overlay(
                Group {
                    if !user.login {
                        LoginView(login: $showLogin, showBG: true, successAction: {
                            alertText = "登录成功"
                            showAlert = true
                        }, failAction: {
                            alertText = "登录失败，请重试"
                            alertType = .error()
                            showAlert = true
                        })
                    }
                }, alignment: .bottom
            )
            .sheet(isPresented: $showPro) {
                ProView().sheetFrameForMac()
            }
            .ignoresSafeArea()
        #if os(iOS)
            .fullScreenCover(item: $searchText) { search in
                SheetSearchView(searchText: search)
            }
        #else
            .overlay(alignment: .topTrailing) {
                MacCloseButton()
                    .padding(26)
            }
            .sheet(item: $searchText) { search in
                SheetSearchView(searchText: search)
            }
        #endif
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .alert, type: alertType, title: alertText)
            }
            .onChange(of: selection, perform: { _ in
                detail.loading = true
                detail.detail = nil
            })
            .onAppear {
                let id = shoots[0].id
                Task {
                    await detail.getImageLinked(id: id) { linked in
                        let group = Dictionary(grouping: linked, by: { $0.bindOrToBind })
                        
                        if let befores = group["2"] {
                            var array: [Picture] = []
                            befores.forEach { pic in
                                array.append(Picture(id: pic.id, picUrl: pic.picUrl, linkApplicationId: pic.linkApplicationId, linkApplicationOfficialId: pic.linkApplicationOfficialId, chooseType: pic.chooseType))
                            }
                            
                            withAnimation(.spring()) {
                                shoots.insert(contentsOf: array, at: 0)
                            }
                            selection = shoots.count - 1
                        }
                        if let afters = group["1"] {
                            var array: [Picture] = []
                            afters.forEach { pic in
                                array.append(Picture(id: pic.id, picUrl: pic.picUrl, linkApplicationId: pic.linkApplicationId, linkApplicationOfficialId: pic.linkApplicationOfficialId, chooseType: pic.chooseType))
                            }
                            withAnimation(.spring()) {
                                shoots.append(contentsOf: array)
                            }
                        }
                    }
                }
            }
    }
    
    @ViewBuilder
    var content: some View {
        #if os(iOS)
        TabView(selection: $selection) {
            ForEach(shoots.indices, id: \.self) { indice in
                ScrollView(showsIndicators: false) {
                    ImageView(urlString: shoots[indice].type == .gif ? shoots[indice].gifPicUrl : shoots[indice].compressedPicUrl, isGif: shoots[indice].type == .gif, image: $image)
                        .frame(maxWidth: 460)
                        .padding(.top)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .background(Color.shootLight.opacity(0.1))
                    .tag(indice)
                    .onTapGesture {
                        #if os(iOS)
                        FeedbackManager.impact(style: .soft)
                        #endif
                        if showSave {
                            withAnimation(.spring()) {
                                showSave = false
                            }
                        } else {
                            withAnimation(.spring()) {
                                showDetail.toggle()
                            }
                        }
                    }
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .top) {
                indicatorView
            }
        #else
        if shoots.count == 1 {
            ScrollView(showsIndicators: false) {
                ImageView(urlString: shoots[0].type == .gif ? shoots[0].gifPicUrl : shoots[0].compressedPicUrl, isGif: shoots[0].type == .gif, image: $image)
                    .frame(maxWidth: 460)
                    .padding(.top)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }.background(Color.shootLight.opacity(0.1))
                .onTapGesture {
                    #if os(iOS)
                    FeedbackManager.impact(style: .soft)
                    #else
                    selection = 0
                    #endif
                    if showSave {
                        withAnimation(.spring()) {
                            showSave = false
                        }
                    } else {
                        withAnimation(.spring()) {
                            showDetail.toggle()
                        }
                    }
                }
        } else {
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shoots.indices, id: \.self) { indice in
                            ScrollView(showsIndicators: false) {
                                ImageView(urlString: shoots[indice].type == .gif ? shoots[indice].gifPicUrl : shoots[indice].compressedPicUrl, isGif: shoots[indice].type == .gif, image: $image)
                                    .frame(maxWidth: 460)
                                    .padding(.top)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            }.background(Color.shootLight.opacity(0.1))
                                .id(indice)
                                .onTapGesture {
                                    #if os(iOS)
                                    FeedbackManager.impact(style: .soft)
                                    #else
                                    selection = indice
                                    #endif
                                    if showSave {
                                        withAnimation(.spring()) {
                                            showSave = false
                                        }
                                    } else {
                                        withAnimation(.spring()) {
                                            showDetail.toggle()
                                        }
                                    }
                                }
                        }
                    }
                }
                .onAppear {
                    value.scrollTo(1, anchor: .center)
                }
            }
        }
        #endif
    }

    @State var showApp = false
    @State var showReport = false
    @State var designTypes: [String] = []
    @State var showContent = false
    @State var showPro = false
    var infoView: some View {
        VStack(spacing: 16) {
            if showDetail {
                if detail.loading {
                    LoadingView()
                        .frame(height: 160)
                        .onAppear {
                            let id = shoots[selection].id
                            Task {
                                await detail.getImageDetail(id: id) { _ in
                                }
                            }
                        }
                } else {
                    if let detail = detail.detail {
                        // 顶部应用按钮
                        Button {
                            showApp.toggle()
                        } label: {
                            HStack {
                                Text(detail.linkApplicationName ?? "应用")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.shootBlack)
                                Image("link")
                            }
                        }.buttonStyle(.plain)
                            .sheet(isPresented: $showApp) {
                                #if os(iOS)
                                    NavigationView {
                                        AppView(id: shoots[selection].linkApplicationId ?? "", appID: detail.appStoreId)
                                            .navigationTitle(detail.linkApplicationName ?? "应用")
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
                                            Text(detail.linkApplicationName ?? "图片详情")
                                                .font(.largeTitle)
                                                .bold()
                                            Spacer()
                                            MacCloseButton()
                                        }.padding([.horizontal, .top], 36)
                                        AppView(id: shoots[selection].linkApplicationId ?? "", appID: detail.appStoreId)
                                    }.sheetFrameForMac()
                                #endif
                            }

                        // 个人信息
                        HStack(spacing: 8) {
                            if let url = detail.avatar {
                                ImageView(urlString: url, image: .constant(nil))
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.2.crop.square.stack")
                                    .font(.system(size: 30, weight: .regular))
                                    .foregroundColor(.shootBlack)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text(LocalizedStringKey(detail.userName ?? "上传用户"))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.shootBlack)

                                HStack(spacing: 4) {
                                    Image("upload")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 16, height: 16)

                                    Group {
                                        Text("\(detail.uploadNum)")
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
                                        Text("\(detail.favoriteNum)")
                                            + Text(" 图片")
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.shootBlack)
                                }
                            }
                            Spacer()
                        }

                        // 设计模式和描述
                        VStack(spacing: 12) {
                            FlowLayout(mode: .vstack,
                                       items: detail.lists,
                                       itemSpacing: 4)
                            { designPattern in
                                if let type = designPattern.type {
                                    Button {
                                        showPro = true
                                    } label: {
                                        Text(designPattern.designPatternName)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.shootBlack)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(type.color)
                                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    }.buttonStyle(.plain)
                                } else {
                                    Button {
                                        search.patternID = designPattern.id
                                        searchText = designPattern.designPatternName.localized
                                        Task {
                                            await search.getPatternPics(id: designPattern.id)
                                        }
                                    } label: {
                                        HStack(spacing: 2) {
                                            Image(systemName: "number")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.shootBlue)
                                            Text(LocalizedStringKey(designPattern.designPatternName))
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.shootBlack)
                                        }.padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.shootBlue.opacity(0.12))
                                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    }.buttonStyle(.plain)
                                }
                            }
                            
                            if let description = detail.picDescription, description != "" {
                                Text(description)
                                    .font(.system(size: 15, weight: .medium))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.shootGray)
                                    .lineSpacing(3)
                                    .blur(radius: showContent ? 0 : 4)
                                    .onTapGesture {
                                        freeClick()
                                    }
                                    .onAppear {
                                        if shoots[selection].type == .image || user.isPro {
                                            withAnimation(.spring()) {
                                                showContent = true
                                            }
                                        }
                                    }
                            }
                        }
                        
                        // 操作按钮
                        HStack {
                            ActionTitleButtonView(systemImage: "sparkles.rectangle.stack.fill", title: "系列") {
                                #if os(iOS)
                                    FeedbackManager.impact(style: .soft)
                                #endif
                                if user.login {
                                    withAnimation(.spring()) {
                                        showDetail = false
                                        showSave = true
                                    }
                                    Task {
                                        await self.detail.getFavorites()
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
                                if #available(iOS 16.0, *) {
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
                                } else {
                                    // TODO:
                                }
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
                                        FeedbackManager.impact(style: .soft)

                                        let imageSaver = ImageSaver()
                                        imageSaver.successHandler = {
                                            alertText = "成功保存到相册"
                                            alertType = .success(Color.shootBlack)
                                            showAlert = true
                                        }
                                        imageSaver.errorHandler = {
                                            print("保存失败: \($0.localizedDescription)")
                                            alertText = "保存失败"
                                            alertType = .error(.red)
                                            showAlert = true
                                        }

                                        guard let url = URL(string: shoots[selection].picUrl) else { return }
                                        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
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
                                ReportView(shoot: shoots[selection]) {
                                    alertText = "反馈成功"
                                    alertType = .success(Color.shootBlack)
                                    showAlert = true
                                }
                                .sheetFrameForMac()
                            }
                        }.padding(.horizontal)
                    } else {
                        ErrorView {}
                            .frame(minHeight: 160)
                    }
                }
            }
        }
            .padding()
            .padding(.bottom)
            .frame(maxWidth: 460, minHeight: 160)
            .frame(maxWidth: .infinity)
            .background(Color.shootWhite)
            .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
            .shadow(color: Color.shootBlack.opacity(0.1), radius: 10, y: -6)
            .contentShape(Rectangle())
    }
    
    @Environment(\.dismiss) var dismiss
    var indicatorView: some View {
        HStack {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .bold))
                .padding(8)
                .background(Color.shootWhite)
                .clipShape(Circle())
                .hidden()
            
            Spacer()
            if shoots.count > 1 {
                HStack(spacing: 4) {
                    ForEach(0..<shoots.count, id: \.self) { indice in
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(selection == indice ? .shootRed : .shootGray)
                            .animation(.spring(), value: selection)
                    }
                }.padding(.horizontal, 6)
                    .padding(.vertical, 4)
                .background(Color.shootWhite)
                    .clipShape(Capsule(style: .continuous))
                    .shadow(color: .shootGray.opacity(0.2), radius: 6, x: 0, y: 0)
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .padding(8)
                    .background(Color.shootWhite)
                    .clipShape(Circle())
                    .shadow(color: .shootLight.opacity(0.4), radius: 10, x: 0, y: 0)
            }.buttonStyle(.plain)
        }.padding()
    }
    @State var showSave = false
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

            if detail.loadingFavorites {
                LoadingView()
                    .frame(height: 286)
            } else {
                if detail.favorites.isEmpty {
                    ShootEmptyView(text: "系列为空")
                        .frame(height: 286)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 26) {
                            ForEach(detail.favorites) { favorite in
                                FolderCardView(images: favorite.pics, name: favorite.favoriteFileName, picCount: favorite.countPics)
                                    .frame(minWidth: 156)
                                    .overlay(
                                        Group {
                                            if favorite.pics.isEmpty {
                                                VStack(spacing: 12) {
                                                    Image(systemName: "plus")
                                                    Text("点击添加到系列")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundColor(.shootGray)
                                                }
                                            }
                                        }
                                    )
                                    .onTapGesture {
                                        let id = shoots[selection].id
                                        // 收藏
                                        Task {
                                            await detail.savePics(pics: [id], favoriteFileId: favorite.id) { _ in
                                                // 收藏成功
                                                showSave = false
                                                // 提示成功
                                                alertText = "添加成功"
                                                alertType = .success(Color.shootBlack)
                                                showAlert = true
                                            }
                                        }
                                    }
                            }
                        }.padding(.horizontal, 26)
                    }
                }
            }
        }
        .padding(.vertical)
        .padding(.bottom)
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
        .background(Color.shootWhite)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.shootBlack.opacity(0.1), radius: 10, y: -10)
        .contentShape(Rectangle())
    }

    @State var name: String = ""
    @State var showNewFolder = false
    @FocusState var focused: Bool
    var newFoldereView: some View {
        VStack(spacing: 26) {
            Text("新建系列")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.shootBlack)

            VStack {
                TextField("输入系列名称", text: $name)
                    .textFieldStyle(.plain)
                    .focused($focused)
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
                        .foregroundColor(.white)
                        .background(Color.shootBlack.opacity(0.4))
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
                                    alertType = .success(Color.shootBlack)
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
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .padding()
            .ignoresSafeArea()
            .onAppear {
                focused = true
            }
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
    
    func freeClick() {
        if !showContent {
            if let date = Defaults().get(for: .day), date.isToday {
                if dayFree < 5 {
                    withAnimation(.spring()) {
                        showContent = true
                    }
                    dayFree += 1
                    // 提示本次查看免费
                    alertText = "VIP 内容，今天还有 \(4 - dayFree) 次查看机会"
                    showAlert = true
                } else {
                    showPro = true
                }
            } else {
                Defaults().set(Date(), for: .day)
                withAnimation(.spring()) {
                    showContent = true
                }
                dayFree = 0
                // 提示本次查看免费
                alertText = "VIP 内容，本次查看免费，今天还有 4 次查看机会"
                showAlert = true
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(shoots: [Picture(id: "", picUrl: "", chooseType: "")])
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
            .environmentObject(UserViewModel())
        DetailView(shoots: [Picture(id: "", picUrl: "", chooseType: "")])
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(UserViewModel())
    }
}
