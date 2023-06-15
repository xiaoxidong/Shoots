//
//  CombineView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct CombineSelectView: View {
    @Binding var uploadImages: [UIImage]
    
    @Environment(\.dismiss) var dismiss
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    
    @State var combinedImage: UIImage? = nil
    @State var showCombine = false
    @State var showAlert = false
    var body: some View {
        NavigationView {
            ScrollView {
                Divider()
                selectView
            }
            .navigationTitle("选择图片进行拼接")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                            .padding(.vertical, 6)
                            .padding(.trailing, 6)
                            .contentShape(Rectangle())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if chectSameSize() {
                            showCombine = true
                        } else {
                            // 提示不一样的尺寸不能拼接
                            showAlert.toggle()
                        }
                    }, label: {
                        Text("拼接")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .contentShape(Rectangle())
                    })
                    .disabled(selected.count < 2)
                    .background(
                        NavigationLink(destination: CombineView(images: selected, combinedImage: $combinedImage) {
                            selected.forEach { image in
                                if let index = uploadImages.firstIndex(of: image) {
                                    uploadImages.remove(at: index)
                                }
                            }
                            if let combinedImage = combinedImage {
                                uploadImages.append(combinedImage)
                            }
                            dismiss()
                        }, isActive: $showCombine) {
                            EmptyView()
                        }
                    )
                }
            }
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .alert, type: .error(), title: "尺寸不一致无法拼接")
            }
        }
    }
    
    var columns: [GridItem] {
        if horizontalSizeClass == .compact {
            return [GridItem(.adaptive(minimum: 120, maximum: 260), spacing: 2)]
        } else {
            return [GridItem(.adaptive(minimum: 220, maximum: 360), spacing: 2)]
        }
    }
    @State var selected: [UIImage] = []
    var selectView: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 2) {
                ForEach(uploadImages, id: \.self) { image in
                    Button(action: {
                        //选择和取消选择截图
                        withAnimation(.spring()) {
                            if selected.contains(image), let index = selected.firstIndex(of: image) {
                                selected.remove(at: index)
                            } else {
                                selected.append(image)
                            }
                        }
                    }, label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, alignment: .top)
                            .overlay(alignment: .bottomLeading) {
                                Image(systemName: "checkmark.circle.fill")
                                    .padding(12)
                                    .foregroundColor(selected.contains(image) ? Color.shootRed : Color.shootWhite)
                                    .shadow(radius: 6)
                            }
                    })
                }
            }
        }
    }
    
    func chectSameSize() -> Bool {
        var width: CGFloat? = nil
        var same = true
        for image in selected {
            if width == nil {
                width = image.size.width
            } else {
                if width != image.size.width {
                    // 尺寸不一样不能拼接
                    same = false
                    break
                }
            }
        }
        return same
    }
}

struct CombineSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CombineSelectView(uploadImages: .constant([UIImage(named: "s1")!, UIImage(named: "s2")!]))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        CombineSelectView(uploadImages: .constant([UIImage(named: "s1")!, UIImage(named: "s2")!]))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
