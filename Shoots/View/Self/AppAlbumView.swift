//
//  AppAlbumView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/18.
//

import SwiftUI

struct AppAlbumView: View {
    var id: String
    var name: String
    
    @State var edit = false
    @State var delete = false
    @Environment(\.dismiss) var dismiss
    @StateObject var selfAppDetail = SelfAppViewModel()
    @EnvironmentObject var user: UserViewModel
    @State var showToast = false
    @State var toastText = ""
    @State var alertType: AlertToast.AlertType = .success(.black)
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
                    Text(name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.shootBlack)
                        .lineLimit(1)
                        .frame(maxWidth: 200)
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
                Text(name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.shootBlack)
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
                
            }.padding(.top, 36)
                .padding(.horizontal)
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
                    .opacity(delete ? 0.2 : 0)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            delete = false
                        }
                    }
                if delete {
                    deleteView
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
        )
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: alertType, title: toastText)
        }
        .onAppear {
            getData()
        }
    }
    
    var feed: some View {
        ScrollView {
            VStack(spacing: 0) {
                FeedView(shoots: selfAppDetail.appFeed)
                
                LoadMoreView(footerRefreshing: $selfAppDetail.footerRefreshing, noMore: $selfAppDetail.noMore) {
                    loadMore()
                }
            }
        }.enableRefresh()
            .refreshable {
                // 首页下拉刷新
                getData()
            }
    }
    
    func loadMore() {
        if self.selfAppDetail.page + 1 > self.selfAppDetail.mostPages {
            self.selfAppDetail.footerRefreshing = false
            self.selfAppDetail.noMore = true
        } else {
            Task {
                await self.selfAppDetail.nextPage(id: id)
            }
        }
    }
    
    func getData() {
        Task {
            await self.selfAppDetail.nextPage(id: id)
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
                ForEach(selfAppDetail.appFeed) { shoot in
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
        }.background(Color.shootLight.opacity(0.06))
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
                        await selfAppDetail.deletePics(ids: selected, { success in
                            if success {
                                toastText = "成功删除"
                                alertType = .success(.black)
                                showToast = true
                            } else {
                                toastText = "删除失败，请重试"
                                alertType = .error(.red)
                                showToast = true
                            }
                        })
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

struct AppAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AppAlbumView(id: "", name: "")
    }
}
