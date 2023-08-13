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
    @StateObject var selfPic: SelfViewModel = .init()
    @EnvironmentObject var user: UserViewModel
    @State var editInfo = false
    var body: some View {
        #if os(iOS)
            content
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

                    ToolbarItem(placement: .principal) {
                        Button {
                            editInfo.toggle()
                        } label: {
                            HStack(spacing: 6) {
                                if let avatar = user.avatar {
                                    ImageView(urlString: avatar, image: .constant(nil))
                                        .frame(width: 26, height: 26)
                                        .clipShape(Circle())
                                }

                                Group {
                                    if user.name != "" {
                                        Text(user.name)
                                    } else {
                                        Text("我的图片")
                                    }
                                }.font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.shootGray)
                            }
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
                .sheet(isPresented: $editInfo) {
                    InfoView {
//                        toastText = "更新成功"
//                        showToast = true
                        Task {
                            await user.getInfo()
                        }
                    }
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled()
                }
        #else
            VStack {
                HStack {
                    Button {
                        editInfo.toggle()
                    } label: {
                        HStack(spacing: 8) {
                            if let avatar = user.avatar {
                                ImageView(urlString: avatar, image: .constant(nil))
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())
                            }

                            Group {
                                if user.name != "" {
                                    Text(user.name)
                                } else {
                                    Text("我的图片")
                                }
                            }
                            .font(.title)
                            .bold()
                        }
                    }.buttonStyle(.plain)
                    
                    Spacer()
                    MacCloseButton()
                }.padding(.top, 36)
                    .padding(.horizontal)
                content
            }.sheet(isPresented: $editInfo) {
                InfoView {
//                    toastText = "更新成功"
//                    showToast = true
                }.frame(width: 400, height: 400)
            }
        #endif
    }

    @ViewBuilder
    var content: some View {
        if selfPic.loading {
            LoadingView()
                .onAppear {
                    Task {
                        await selfPic.getFavorites()
                        await selfPic.uploadPicGroup()
                    }
                }
        } else {
            if selfPic.apps.isEmpty && selfPic.favorites.isEmpty {
                VStack {
                    Spacer()
                    ShootEmptyView(text: "还没有上传和添加到系列任何截图")
                    Spacer()
                }
            } else {
                picView
            }
        }
    }

    var picView: some View {
        VStack(spacing: 0) {
            if showTag {
                tagView
                if selfPic.loadingPattern {
                    LoadingView()
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            // 列表
                            FeedView(shoots: selfPic.patternFeed)

                            LoadMoreView(footerRefreshing: self.$selfPic.footerRefreshing, noMore: self.$selfPic.noMore) {
                                loadMore()
                            }
                        }
                    }.enableRefresh()
                }
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
    }

    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26),
    ]
    let rows = [
        GridItem(.flexible(minimum: 400, maximum: 400), spacing: 26.0),
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

    @State var id: String = ""
    @State var name: String = ""
    @ViewBuilder
    var upload: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("上传截图")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
            Text(String(format: NSLocalizedString("%d 个应用 %d 张截图", comment: ""), selfPic.apps.count, selfPic.appPicNum))
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.shootGray)
        }.padding(.horizontal)
            .padding(.top, 16)

        #if os(iOS)
            if horizontalSizeClass == .compact {
                LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
                    ForEach(selfPic.apps) { app in
                        NavigationLink {
                            AppAlbumView(id: app.id, name: app.linkApplicationName) {
                                Task {
                                    await selfPic.uploadPicGroup()
                                }
                            }
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
                                AppAlbumView(id: app.id, name: app.linkApplicationName) {
                                    Task {
                                        await selfPic.uploadPicGroup()
                                    }
                                }
                            } label: {
                                FolderCardView(images: app.pics, name: app.linkApplicationName, picCount: app.countPics)
                            }
                        }
                    }.padding(.horizontal, 36)
                }.frame(height: 286)
                    .padding(.vertical)
            }
        #else
            LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
                ForEach(selfPic.apps) { app in
                    Button {
                        id = app.id
                        name = app.linkApplicationName
                        showMacFolderView.toggle()
                    } label: {
                        FolderCardView(images: app.pics, name: app.linkApplicationName, picCount: app.countPics)
                    }.buttonStyle(.plain)
                        .sheet(isPresented: $showMacFolderView) {
                            AppAlbumView(id: app.id, name: app.linkApplicationName) {
                                Task {
                                    await selfPic.uploadPicGroup()
                                }
                            }
                            .sheetFrameForMac()
                        }
                }
            }.padding(.horizontal)

        #endif
    }

    @ViewBuilder
    var favorite: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("系列")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
            Text(String(format: NSLocalizedString("%d 个系列 %d 张截图", comment: ""), selfPic.favorites.count, selfPic.favoritesPicNum))
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.shootGray)
        }.padding(.horizontal)
            .padding(.top, 36)

        #if os(iOS)
            if horizontalSizeClass == .compact {
                LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
                    ForEach($selfPic.favorites) { $favorite in
                        NavigationLink {
                            FavoriteAlbumView(id: favorite.id, name: $favorite.favoriteFileName) {
                                Task {
                                    await selfPic.getFavorites()
                                }
                            }
                        } label: {
                            FolderCardView(images: favorite.pics, name: favorite.favoriteFileName, picCount: favorite.countPics)
                        }
                    }
                }.padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows, alignment: .center, spacing: 46) {
                        ForEach($selfPic.favorites) { $favorite in
                            NavigationLink {
                                FavoriteAlbumView(id: favorite.id, name: $favorite.favoriteFileName) {
                                    Task {
                                        await selfPic.getFavorites()
                                    }
                                }
                            } label: {
                                FolderCardView(images: favorite.pics, name: favorite.favoriteFileName, picCount: favorite.countPics)
                            }
                        }
                    }.padding(.horizontal, 36)
                }.frame(height: 286)
                    .padding(.vertical)
            }
        #else
            LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
                ForEach($selfPic.favorites) { $favorite in
                    Button {
                        id = favorite.id
                        name = favorite.favoriteFileName
                        showMacFolderView.toggle()
                    } label: {
                        FolderCardView(images: favorite.pics, name: favorite.favoriteFileName, picCount: favorite.countPics)
                    }.buttonStyle(.plain)
                        .sheet(isPresented: $showMacFolderView) {
                            FavoriteAlbumView(id: favorite.id, name: $favorite.favoriteFileName) {
                                Task {
                                    await selfPic.getFavorites()
                                }
                            }
                            .sheetFrameForMac()
                        }
                }
            }.padding(.horizontal)

        #endif
    }

    func loadMore() {
        if !selfPic.noMore, selfPic.page + 1 > selfPic.mostPages {
            selfPic.footerRefreshing = false
            selfPic.noMore = true
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
