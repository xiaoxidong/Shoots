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
    var body: some View {
        ScrollView {
            if showTag {
                tagView
            } else {
                folderView
            }
        }.navigationTitle("Xiaodong")
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image("setting")
                    }
                    
                }
            }
    }
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 26)
    ]
    
    @State var tags: [String] = ["Feed", "Friends", "Settings", "Cards", "Live", "Maps", "Follwer", "Help", "Shop"]
    @State var selected = "Feed"
    var tagView: some View {
        VStack {
            VStack {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(tags, id: \.self) { text in
                                Button {
                                    withAnimation(.spring()) {
                                        selected = text
                                    }
                                } label: {
                                    Text(text)
                                        .font(.system(size: selected == text ? 17 : 15, weight: selected == text ? .bold : .medium))
                                        .foregroundColor(selected == text ? .shootBlue : .shootBlack)
                                        .padding(.bottom, 12)
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
                    }.padding(.trailing)
                }.padding(.top)
                
                Divider()
            }
            
            // 列表
            FeedView(shoots: homeData)
        }
    }
    
    var folderView: some View {
        VStack {
            VStack {
                HStack {
                    Text("12 个收藏夹和 34 图片已上传")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.shootGray)
                    Spacer()
                    Button {
                        withAnimation(.spring()) {
                            showTag.toggle()
                        }
                    } label: {
                        Image("tags")
                    }
                }.padding(.top)
                    
                Divider()
            }
            Text("上传截图")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
                ForEach(1..<11) { index in
                    NavigationLink {
                        AlbumView()
                    } label: {
                        VStack(spacing: 12) {
                            ZStack {
                                Image("s1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .rotationEffect(Angle(degrees: -3))
                                Image("s1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .rotationEffect(Angle(degrees: -6))
                                Image("s1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .shadow(color: Color.shootBlack.opacity(0.1), radius: 12)
                            .overlay(alignment: .bottomLeading) {
                                Text("129 张")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .foregroundColor(.white)
                                    .background(Color.shootRed.opacity(0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                    .padding(6)
                                    .offset(x: -4)
                            }
                            
                            Text("Instagram")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.shootBlack)
                        }
                    }
                }
            }
            
            Text("收藏截图")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 36)
                .padding(.bottom, 12)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 26) {
                ForEach(1..<10) { index in
                    NavigationLink {
                        AlbumView()
                    } label: {
                        VStack(spacing: 12) {
                            ZStack {
                                Image("s1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .rotationEffect(Angle(degrees: -3))
                                Image("s1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .rotationEffect(Angle(degrees: -6))
                                Image("s1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .shadow(color: Color.shootBlack.opacity(0.1), radius: 12)
                            .overlay(alignment: .bottomLeading) {
                                Text("129 张")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .foregroundColor(.white)
                                    .background(Color.shootRed)
                                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                    .padding(6)
                            }
                            
                            Text("Instagram")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.shootBlack)
                        }
                    }
                    
                }
            }
        }.padding(.horizontal)
    }
}

struct SelfView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelfView()
        }
    }
}
