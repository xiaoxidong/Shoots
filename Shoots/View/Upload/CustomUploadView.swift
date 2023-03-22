//
//  CustomUploadView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/22.
//

import SwiftUI

struct CustomUploadView: View {
    @Environment(\.dismiss) var dismiss
    @State var photos: [String] = []
    @State var finish = false
    var body: some View {
        NavigationView {
            Group {
                if finish {
                    if !photos.isEmpty {
                        ShootEmptyView(text: "未扫描到任何截图")
                    } else {
                        photoView
                    }
                } else {
                    VStack(spacing: 16) {
                        DNALoading()
                        Text("本地扫描截图中...")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.shootGray)
                    }
                }
            }.navigationTitle(finish && photos.isEmpty ? "选择应用" : "扫描截图")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.shootBlack)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Text("上传")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.shootBlue)
                        }
                    }
                }
        }
        .overlay(
            addAppView, alignment: .bottom
        )
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            #if DEBUG
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                finish = true
            }
            #endif
        }
    }
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 2),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 2),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 2)
    ]
    
    var photoView: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 2) {
                ForEach(homeData) { shoot in
                    Image(shoot.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .onDrag {
                            return NSItemProvider(object: shoot.imageUrl as NSItemProviderWriting)
                        }
                }
            }
        }
    }
    
    var addAppView: some View {
        Group {
            VStack(spacing: 22) {
                HStack {
                    Text("选择操作")
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.shootBlue)
                            .padding(4)
                            .contentShape(Rectangle())
                    }
                }.padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        FolderCardView(images: ["s1", "s2"], name: "Instagram")
                        FolderCardView(images: ["s1", "s2"], name: "Instagram")
                        FolderCardView(images: ["s1", "s2"], name: "Instagram")
                        FolderCardView(images: ["s1", "s2"], name: "Instagram")
                    }.padding(.horizontal)
                }
                
            }.frame(maxWidth: .infinity)
                .padding(.bottom, 36)
                .padding(.top, 8)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color.shootBlack.opacity(0.1), radius: 10, y: -10)
            .offset(y: !finish ? 1000 : 0)
        }
    }
    
}

struct CustomUploadView_Previews: PreviewProvider {
    static var previews: some View {
        CustomUploadView()
    }
}
