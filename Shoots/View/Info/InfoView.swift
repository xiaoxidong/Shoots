//
//  InfoView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/10.
//

import SwiftUI

struct InfoView: View {
    let action: () -> Void
    
    @State var inputImage: UIImage? = nil
    @State var cropImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var showEditor = false
    @FocusState var focused: Bool
    
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var user: UserViewModel
    var body: some View {
        NavigationView {
            VStack(spacing: 26) {
                // TODO: 裁剪的时候如何是横版的图片，缩放的时候可能会出现白边的情况
                Button {
                    isShowingImagePicker.toggle()
                } label: {
                    Group {
                        if let image = cropImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if let url = user.avatar {
                            ImageView(urlString: url, image: .constant(nil))
                        } else {
                            Image(systemName: "photo.circle.fill")
                        }
                    }.frame(width: 206, height: 206)
                        .background(Color("shootWhite"))
                        .clipShape(Circle())
                        .shadow(color: Color.gray.opacity(0.16), radius: 10, x: 0, y: 0)
                }.padding(.top)

                TextField("输入昵称", text: $user.name)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.shootGray)
                    .focused($focused)
                Spacer()
            }.navigationTitle("编辑信息")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            mode.wrappedValue.dismiss()
                        } label: {
                            Text("取消")
                                .font(.system(size: 16, weight: .bold))
                                .padding(4)
                                .contentShape(Rectangle())
                                .foregroundColor(.shootGray)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if user.avatar == nil {
                                if let image = cropImage, user.name != "" {
                                    Task {
                                        await user.uploadAvatar(image: image.pngData()!) { success in
                                            if success {
                                                Task {
                                                    await user.updateInfo(name: user.name) { success in
                                                        if success {
                                                            mode.wrappedValue.dismiss()
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
                                        Task {
                                            await user.uploadAvatar(image: image.pngData()!) { success in
                                                if success {
                                                    Task {
                                                        await user.updateInfo(name: user.name) { success in
                                                            if success {
                                                                mode.wrappedValue.dismiss()
                                                                action()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        Task {
                                            await user.updateInfo(name: user.name) { success in
                                                if success {
                                                    mode.wrappedValue.dismiss()
                                                    action()
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    // 请输入用户名
                                    
                                }
                            }
                            
                        } label: {
                            Text("保存")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.shootBlack)
                                .padding(4)
                                .contentShape(Rectangle())
                        }
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
    
    @State var inputImageAspectRatio: CGFloat = 0.0
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        showEditor.toggle()
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView() { }
    }
}
