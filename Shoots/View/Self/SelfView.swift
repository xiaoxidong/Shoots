//
//  SelfView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct SelfView: View {
    @State var showTag = false
    @Environment(\.dismiss) var dismiss
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    @StateObject var selfPic: SelfViewModel = SelfViewModel()
    var body: some View {
        #if os(iOS)
        content
            .navigationTitle("我的图片")
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.shootBlack)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.vertical, 6)
                                .padding(.trailing, 6)
                                .contentShape(Rectangle())
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SettingView()
                        } label: {
                            Image("setting")
                                .renderingMode(.template)
                                .foregroundColor(.shootBlue)
                                .padding(.vertical, 6)
                                .padding(.leading, 6)
                                .contentShape(Rectangle())
                        }
                        
                    }
                }
        #else
        VStack {
            HStack {
                Text("Xiaodong")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                MacCloseButton()
            }.padding([.horizontal, .top], 36)
            content
        }
        #endif
    }
    
    @ViewBuilder
    var content: some View {
        VStack(spacing: 0) {
            if showTag {
                tagView
                ScrollView {
                    // 列表
                    FeedView(shoots: selfPic.patternFeed)
                    
                    LoadMoreView(footerRefreshing: self.$selfPic.footerRefreshing, noMore: self.$selfPic.noMore) {
                        loadMore()
                    }
                }.enableRefresh()
            } else {
                VStack {
                    HStack {
                        Text("上传应用截图和系列")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.shootGray)
                        Spacer()
                        Button {
                            withAnimation(.spring()) {
                                showTag.toggle()
                            }
                            if showTag && selfPic.userPattern.isEmpty {
                                Task {
                                    await selfPic.getUserPattern()
                                }
                            }
                        } label: {
                            Image("tags")
                        }.buttonStyle(.plain)
                    }.padding(.top)
                        
                    Divider()
                }.padding(.horizontal)
                
                ScrollView {
                    folderView
                }
            }
        }
        .onAppear {
            Task {
                await selfPic.getFavorites()
                await selfPic.uploadPicGroup()
            }
        }
    }
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26)
    ]
    let rows = [
        GridItem(.flexible(minimum: 400, maximum: 400), spacing: 26.0)
    ]
    
    @State var selected = ""
    var tagView: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(selfPic.userPattern, id: \.self) { pattern in
                        Button {
                            withAnimation(.spring()) {
                                selected = pattern.designPatternName
                            }
                            
                            Task {
                                await selfPic.getPatternPics(id: pattern.id)
                            }
                        } label: {
                            Text(pattern.designPatternName)
                                .font(.system(size: selected == pattern.designPatternName ? 17 : 15, weight: selected == pattern.designPatternName ? .bold : .medium))
                                .foregroundColor(selected == pattern.designPatternName ? .shootBlue : .shootBlack)
                                .padding(.bottom, 12)
                        }.buttonStyle(.plain)
                    }.onAppear {
                        if let pattern = selfPic.userPattern.first {
                            selected = pattern.designPatternName
                            Task {
                                await selfPic.getPatternPics(id: pattern.id)
                            }
                        }
                    }
                }.padding(.horizontal)
            }
            Button {
                withAnimation(.spring()) {
                    showTag.toggle()
                }
            } label: {
                Image("grouped")
                    .padding(.bottom, 12)
            }.buttonStyle(.plain)
                .padding(.trailing)
        }.padding(.top)
    }
    
    @State var showMacFolderView = false
    var folderView: some View {
        VStack(alignment: .leading) {
            if !selfPic.apps.isEmpty {
                upload
            }
            
            if !selfPic.favorites.isEmpty {
                favorite
            }
        }
    }
    
    @ViewBuilder
    var upload: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("上传截图")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
            Text("\(selfPic.apps.count) 个应用 \(selfPic.appPicNum) 张截图")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.shootGray)
        }.padding(.horizontal)
            .padding(.top, 16)
        
        #if os(iOS)
        if horizontalSizeClass == .compact {
            LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
                ForEach(selfPic.apps) { app in
                    NavigationLink {
                        AlbumView(id: "", name: .constant(""))
                    } label: {
                        FolderCardView(images: app.pics, name: app.linkApplicationName, picCount: app.countPics)
                    }
                }
            }.padding(.horizontal)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .center, spacing: 46) {
                    ForEach(selfPic.apps) { app in
                        NavigationLink {
                            AlbumView(id: "", name: .constant(""))
                        } label: {
                            FolderCardView(images: ["s1", "s5", "s3"], name: "Instagram", picCount: 10)
                            
                        }
                    }
                }.padding(.horizontal, 36)
            }.frame(height: 286)
                .padding(.vertical)
        }
        #else
        LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
            ForEach(1..<10) { index in
                Button {
                    showMacFolderView.toggle()
                } label: {
                    FolderCardView(images: ["s1", "s5", "s3"], name: "Instagram", picCount: 10)
                }.buttonStyle(.plain)
            }
        }.padding(.horizontal)
            .sheet(isPresented: $showMacFolderView) {
                AlbumView(id: "", name: .constant(""))
                    .sheetFrameForMac()
            }
        #endif
    }
    
    @ViewBuilder
    var favorite: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("系列")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
            Text("\(selfPic.favorites.count) 个系列 \(selfPic.favoritesPicNum) 张截图")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.shootGray)
        }.padding(.horizontal)
            .padding(.top, 36)
        
        #if os(iOS)
        if horizontalSizeClass == .compact {
            LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
                ForEach($selfPic.favorites) { $favorite in
                    NavigationLink {
                        AlbumView(id: favorite.id, name: $favorite.favoriteFileName)
                    } label: {
                        FolderCardView(images: favorite.pics, name: favorite.favoriteFileName, picCount: favorite.countPics)
                    }
                }
            }.padding(.horizontal)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .center, spacing: 46) {
                    ForEach(1..<11) { index in
                        NavigationLink {
                            AlbumView(id: "", name: .constant(""))
                        } label: {
                            FolderCardView(images: ["s1", "s5", "s3"], name: "Instagram", picCount: 10)
                        }
                    }
                }.padding(.horizontal, 36)
            }.frame(height: 286)
                .padding(.vertical)
        }
        #else
        LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
            ForEach(1..<10) { index in
                Button {
                    showMacFolderView.toggle()
                } label: {
                    FolderCardView(images: ["s1", "s5", "s3"], name: "Instagram", picCount: 10)
                }.buttonStyle(.plain)
            }
        }.padding(.horizontal)
        .sheet(isPresented: $showMacFolderView) {
            AlbumView(id: "", name: .constant(""))
                .sheetFrameForMac()
        }
        #endif
    }
    
    func loadMore() {
        if !self.selfPic.noMore, self.selfPic.page + 1 > self.selfPic.mostPages {
            self.selfPic.footerRefreshing = false
            self.selfPic.noMore = true
        } else {
            Task {
                await selfPic.nextPage(id: selected)
            }
        }
    }
}

struct SelfView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelfView()
        }
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        NavigationView {
            SelfView()
        }
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
