//
//  SelfView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct SelfView: View {
    @State var showTag = false
    var body: some View {
        ScrollView {
            if showTag {
                tagView
            } else {
                folderView
            }
        }.navigationTitle("Xiaodong")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
    
    var tagView: some View {
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
                        Image("grouped")
                    }
                }.padding(.top)
                
                Divider()
            }
            
            // 列表
            
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
