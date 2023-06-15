//
//  AlbumView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import Alamofire

struct AlbumView: View {
    var id: String
    @Binding var name: String
    
    @State var edit = false
    @State var showEditName = false
    @State var delete = false
    @Environment(\.dismiss) var dismiss
    @StateObject var favoriteDetail = FavoriteDetailViewModel()
    @EnvironmentObject var user: UserViewModel
    
    var body: some View {
        #if os(iOS)
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if edit {
                            withAnimation(.spring()) {
                                delete.toggle()
                            }
                        } else {
                            dismiss()
                        }
                    } label: {
                        if edit {
                            Text("删除")
                                .bold()
                                .foregroundColor(selected.isEmpty ? .shootGray : .shootRed)
                        } else {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.shootBlack)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }.disabled(edit && selected.isEmpty)
                }
                
                ToolbarItem(placement: .principal) {
                    Button {
                        editName = name
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showEditName.toggle()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.shootBlack)
                                .lineLimit(1)
                                .frame(maxWidth: 200)
                            Image("edit")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.spring()) {
                            edit.toggle()
                        }
                    } label: {
                        Text(edit ? "完成" : "管理")
                            .bold()
                            .foregroundColor(.shootBlue)
                    }
                }
            }
        #else
        VStack {
            HStack {
                Button {
                    withAnimation(.spring()) {
                        edit.toggle()
                    }
                } label: {
                    Text(edit ? "完成" : "管理")
                        .bold()
                        .foregroundColor(.shootBlue)
                }.buttonStyle(.plain)
                
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showEditName.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.shootBlack)
                        Image("edit")
                    }
                }.buttonStyle(.plain)
                Spacer()
                Button {
                    if edit {
                        withAnimation(.spring()) {
                            delete.toggle()
                        }
                    } else {
                        dismiss()
                    }
                } label: {
                    if edit {
                        Text("删除")
                            .bold()
                            .foregroundColor(selected.isEmpty ? .shootGray : .shootRed)
                    } else {
                        MacCloseButton()
                    }
                }.disabled(edit && selected.isEmpty)
                    .buttonStyle(.plain)
                
            }.padding([.horizontal, .top], 36)
            content
        }
        #endif
            
    }
    
    var content: some View {
        VStack {
            if edit {
                editView
            } else {
                feed
            }
        }.overlay(
            Group {
                Color.black
                    .ignoresSafeArea()
                    .opacity(showEditName || delete ? 0.2 : 0)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showEditName = false
                            delete = false
                        }
                    }
                if showEditName {
                    editNameView
                        .transition(.scale(scale: 0.6).combined(with: .opacity))
                }
                if delete {
                    deleteView
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
        )
        .onAppear {
            getData()
        }
    }
    
    var feed: some View {
        ScrollView {
            FeedView(shoots: favoriteDetail.favoriteFeed)
            
            LoadMoreView(footerRefreshing: $favoriteDetail.footerRefreshing, noMore: $favoriteDetail.noMore) {
                loadMore()
            }
        }.enableRefresh()
            .refreshable {
                // 首页下拉刷新
                getData()
            }
            .background(Color.shootLight.opacity(0.2))
    }
    
    func loadMore() {
        if self.favoriteDetail.page + 1 > self.favoriteDetail.mostPages {
            self.favoriteDetail.footerRefreshing = false
            self.favoriteDetail.noMore = true
        } else {
            Task {
                await self.favoriteDetail.nexPage(id: id)
            }
        }
    }
    
    func getData() {
        Task {
            await self.favoriteDetail.favoritePics(id: id)
        }
    }
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    
    var columns: [GridItem] {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            return [GridItem(.adaptive(minimum: 120, maximum: 260), spacing: 2)]
        } else {
            return [GridItem(.adaptive(minimum: 220, maximum: 360), spacing: 2)]
        }
        #else
        return [GridItem(.adaptive(minimum: 120, maximum: 260), spacing: 2)]
        #endif
    }
    
    @State var selected: [String] = []
    var editView: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 2) {
                ForEach(favoriteDetail.favoriteFeed) { shoot in
                    Button(action: {
                        //选择和取消选择截图
                        withAnimation(.spring()) {
                            if selected.contains(shoot.id), let index = selected.firstIndex(of: shoot.id) {
                                selected.remove(at: index)
                            } else {
                                selected.append(shoot.id)
                            }
                        }
                    }, label: {
                        ImageView(urlString: shoot.compressedPicUrl, image: .constant(nil))
                            .frame(maxWidth: .infinity, alignment: .top)
                            .overlay(alignment: .bottomLeading) {
                                Image(systemName: "checkmark.circle.fill")
                                    .padding(12)
                                    .foregroundColor(selected.contains(shoot.id) ? Color.shootRed : Color.white)
                                    .shadow(radius: 6)
                            }
                    }).buttonStyle(.plain)
                }
            }
        }.background(Color.shootLight.opacity(0.2))
    }
    
    @State var editName: String = ""
    var editNameView: some View {
        VStack(spacing: 26) {
            Text("编辑系列")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.shootBlack)
            
            VStack {
                TextField("输入系列名称", text: $editName)
                    .textFieldStyle(.plain)
                    .padding(.horizontal)
                Divider()
            }
            
            HStack(spacing: 56) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showEditName.toggle()
                    }
                } label: {
                    Text("取消")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                        .background(Color.shootGray.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }.buttonStyle(.plain)
                Button {
                    Task {
                        await favoriteDetail.editFavoriteName(id: id, name: editName) { success in
                            if success {
                                name = editName
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showEditName.toggle()
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
    
    var deleteView: some View {
        VStack(spacing: 26) {
            Text("确认删除？")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
            
            Text("删除之后将无法恢复，确认删除？")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.shootBlack)
            
            HStack(spacing: 56) {
                Button {
                    withAnimation(.spring()) {
                        delete = false
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
                    Task {
                        await favoriteDetail.removeFavorite(pics: selected, id: id) { success in
                            
                        }
                    }
                    withAnimation(.spring()) {
                        delete = false
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
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlbumView(id: "", name: .constant(""))
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
        }
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        NavigationView {
            AlbumView(id: "", name: .constant(""))
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
        }
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
