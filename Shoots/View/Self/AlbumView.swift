//
//  AlbumView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct AlbumView: View {
    
    @State var edit = false
    @State var editName = false
    @State var delete = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            if edit {
                editView
            } else {
                FeedView(shoots: homeData)
            }
        }
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
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }.disabled(edit && selected.isEmpty)
                }
                
                ToolbarItem(placement: .principal) {
                    Button {
                        withAnimation(.spring()) {
                            editName.toggle()
                        }
                    } label: {
                        HStack(spacing: 2) {
                            Text("Poke")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.shootBlack)
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
            .overlay(
                Group {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(editName || delete ? 0.2 : 0)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                editName = false
                                delete = false
                            }
                        }
                    if editName {
                        editNameView
                            .transition(.scale(scale: 0.6).combined(with: .opacity))
                    }
                    if delete {
                        deleteView
                            .transition(.scale(scale: 0.6).combined(with: .opacity))
                    }
                }
            )
    }
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    
    var columns: [GridItem] {
        if horizontalSizeClass == .compact {
            return [GridItem(.adaptive(minimum: 120, maximum: 260), spacing: 2)]
        } else {
            return [GridItem(.adaptive(minimum: 220, maximum: 360), spacing: 2)]
        }
    }
    
    @State var selected: [String] = []
    var editView: some View {
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
    
    @State var name: String = ""
    var editNameView: some View {
        VStack(spacing: 26) {
            Text("编辑收藏夹")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.shootBlack)
            
            VStack {
                TextField("输入收藏夹名称", text: $name)
                    .padding(.horizontal)
                Divider()
            }
            
            HStack(spacing: 56) {
                Button {
                    withAnimation(.spring()) {
                        editName = false
                    }
                } label: {
                    Text("取消")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                        .background(Color.shootLight.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                Button {
                    withAnimation(.spring()) {
                        editName = false
                    }
                } label: {
                    Text("确认")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Color.shootRed)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }.padding()
            .padding(.vertical)
            .frame(maxWidth: 460)
            .background(Color.white)
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
                }
                Button {
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
                }
            }
        }.padding()
            .padding(.vertical)
            .frame(maxWidth: 460)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding()
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlbumView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
