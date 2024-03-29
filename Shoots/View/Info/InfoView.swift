//
//  InfoView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/10.
//

import SwiftUI
import UniformTypeIdentifiers

struct InfoView: View, DropDelegate {
    let action: () -> Void

    #if os(iOS)
    @State var inputImage: UIImage? = nil
    @State var cropImage: UIImage? = nil
    #else
    @State var inputImage: NSImage? = NSImage(systemSymbolName: "photo", accessibilityDescription: "")
    @State var cropImage: NSImage? = nil
    #endif
    @State private var isShowingImagePicker = false
    @State private var showEditor = false
    @FocusState var focused: Bool

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: UserViewModel
    @State private var name: String = ""
    @State var dragOver = false
    var body: some View {
        #if os(iOS)
        iOS
            .overlay(
                updatingView
            )
        #else
        mac
            .overlay(
                updatingView
            )
        #endif
    }

    #if os(iOS)
    var iOS: some View {
        NavigationView {
            content
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("取消")
                                .font(.system(size: 16, weight: .bold))
                                .padding(4)
                                .contentShape(Rectangle())
                                .foregroundColor(.shootGray)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("编辑信息")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.shootBlack)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        saveButton
                    }
                }
        }.sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
            SystemUIImagePicker(image: self.$inputImage)
                .accentColor(Color.systemRed)
        }
        .sheet(isPresented: $showEditor) {
            focused = true
        } content: {
            ImageMoveAndScaleSheet(inputImage: $inputImage, cropImage: $cropImage)
        }
    }
    #else
    var mac: some View {
        VStack {
            HStack {
                MacCloseButton()
                Spacer()
                Text("编辑信息")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.shootGray)
                Spacer()
                saveButton
            }
            
            content
        }.padding()
            .sheet(isPresented: $showEditor) {
                ImageCropperView(inputImage: $inputImage, cropedImage: $cropImage)
                    .frame(width: 600, height: 600)
            }
    }
    #endif
    var content: some View {
        VStack(spacing: 26) {
            // TODO: 裁剪的时候如何是横版的图片，缩放的时候可能会出现白边的情况
            VStack(spacing: 12) {
                Button {
                    #if os(iOS)
                    isShowingImagePicker.toggle()
                    #else
                    NSOpenPanel.openImage { (result) in
                        if case let .success(image) = result {
                            self.inputImage = image
                            showEditor = true
                        }
                    }
                    #endif
                } label: {
                    Group {
                        if let image = cropImage {
                            #if os(iOS)
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            #else
                            Image(nsImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            #endif
                        } else if let url = user.avatar {
                            ImageView(urlString: url, image: .constant(nil))
                        } else {
                            Image(systemName: "photo.circle.fill")
                        }
                    }.frame(width: 206, height: 206)
                        .background(Color("shootWhite"))
                        .clipShape(Circle())
                        .shadow(color: Color.gray.opacity(0.16), radius: 10, x: 0, y: 0)
                }.buttonStyle(.plain)
                .padding(.top)
                .onDrop(of: [.image, .fileURL], delegate: self)
    //            .dropDestination(for: Data.self) { items, location in
    //                guard let item = items.first else { return false }
    //                guard let uiImage = UIImage(data: item) else { return false }
    //                self.inputImage = Image(uiImage: uiImage)
    //                return true
    //            }
                Text("点击选择或拖拽图片添加")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.shootGray)
            }

            TextField("输入昵称", text: $name)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.shootGray)
                .focused($focused)
                .textFieldStyle(.plain)
                .onAppear {
                    self.name = user.name
                }
            Spacer()
        }
    }
    
    @ViewBuilder
    var updatingView: some View {
        if user.updating {
            Color.shootWhite.opacity(0.2)
            LoadingView(text: "更新中...")
        }
    }

    var saveButton: some View {
        Button {
            upload()
        } label: {
            Text("保存")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
                .padding(4)
                .contentShape(Rectangle())
        }.buttonStyle(.plain)
    }

    func upload() {
        if user.avatar == nil {
            if let image = cropImage, user.name != "" {
                #if os(iOS)
                let data = image.pngData()!
                #else
                let data = image.png!
                #endif
                Task {
                    await user.uploadAvatar(image: data) { success in
                        if success {
                            Task {
                                await user.updateInfo(name: name) { success in
                                    if success {
                                        dismiss()
                                        self.user.name = self.name
                                        user.updating = false
                                        action()
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                // 提示上传头像或者输入用户名
            }
        } else {
            // 提示请上传头像
            if user.name != "" {
                if let image = cropImage {
                    #if os(iOS)
                    let data = image.pngData()!
                    #else
                    let data = image.png!
                    #endif
                    Task {
                        await user.uploadAvatar(image: data) { success in
                            if success {
                                Task {
                                    await user.updateInfo(name: name) { success in
                                        if success {
                                            dismiss()
                                            self.user.name = self.name
                                            user.updating = false
                                            action()
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Task {
                        await user.updateInfo(name: name) { success in
                            if success {
                                dismiss()
                                self.user.name = self.name
                                user.updating = false
                                action()
                            }
                        }
                    }
                }
            } else {
                // 请输入用户名
            }
        }
    }

    func loadImage() {
        if inputImage != nil {
            showEditor.toggle()
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if info.hasItemsConforming(to: [.image, .jpeg, .tiff, .gif, .png, .icns, .bmp, .ico, .rawImage, .svg]) {
            let providers = info.itemProviders(for: [.image, .jpeg, .tiff, .gif, .png, .icns, .bmp, .ico, .rawImage, .svg])
            
            let types: [UTType] = [.image, .png, .jpeg, .tiff, .gif, .icns, .ico, .rawImage, .bmp, .svg]
            
            for type in types {
                for provider in providers {
                    if provider.registeredTypeIdentifiers.contains(type.identifier) {
                        provider.loadDataRepresentation(forTypeIdentifier: type.identifier) { data, error in
                            if let data = data {
                                DispatchQueue.main.async {
                                    #if os(macOS)
                                    self.inputImage = NSImage(data: data)
                                    #else
                                    self.inputImage = UIImage(data: data)
                                    #endif
                                    showEditor.toggle()
                                }
                            }
                        }
                        return true
                    }
                }
            }
        }
        return false
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView {}
    }
}
