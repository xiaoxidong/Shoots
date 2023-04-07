//
//  CombineView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct CombineSelectView: View {
    @Environment(\.dismiss) var dismiss
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    
    @State var combinedImage: UIImage? = nil
    @State var images: [UIImage] = [UIImage(named: "s1")!, UIImage(named: "s4")!, UIImage(named: "s4")!]
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
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CombineView(images: images, combinedImage: $combinedImage)
                    } label: {
                        Text("拼接")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }.disabled(selected.isEmpty)
                }
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
    @State var selected: [String] = []
    var selectView: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 2) {
                ForEach(homeData) { shoot in
                    Button(action: {
                        //选择和取消选择截图
                        withAnimation(.spring()) {
                            if selected.contains(shoot.imageUrl), let index = selected.firstIndex(of: shoot.imageUrl) {
                                selected.remove(at: index)
                            } else {
                                selected.append(shoot.imageUrl)
                            }
                        }
                    }, label: {
                        Image(shoot.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, alignment: .top)
                            .overlay(alignment: .bottomLeading) {
                                Image(systemName: "checkmark.circle.fill")
                                    .padding(12)
                                    .foregroundColor(selected.contains(shoot.imageUrl) ? Color.shootRed : Color.white)
                                    .shadow(radius: 6)
                            }
                    })
                }
            }
        }
    }
}

struct CombineSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CombineSelectView()
    }
}
