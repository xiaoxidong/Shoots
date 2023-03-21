//
//  DetailView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import SwiftUIFlowLayout

struct DetailView: View {
    var shoot: Shoot
    
    @State var showDetail = false
    @State var search: String? = nil
    var body: some View {
        ScrollView {
            Image(shoot.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top)
        }
        .overlay(alignment: .bottom) {
            infoView
                .offset(y: showDetail ? 0 : 1000)
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation(.spring()) {
                showDetail.toggle()
            }
        }
        .fullScreenCover(item: $search) { search in
            SearchView(searchText: search)
        }
    }
    
    
    @State var showApp = false
    var infoView: some View {
        VStack(spacing: 16) {
            // 顶部应用按钮
            Button {
                showApp.toggle()
            } label: {
                HStack {
                    Text(shoot.app.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.shootBlack)
                    Image("link")
                }
            }.sheet(isPresented: $showApp) {
                NavigationView {
                    AppView(app: shoot.app)
                        .navigationTitle(shoot.app.name)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "square.and.arrow.up.fill")
                                }.tint(.shootRed)
                            }
                        }
                }
            }

            // 个人信息
            HStack {
                Image(shoot.author.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(shoot.author.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.shootBlack)
                    
                    HStack(spacing: 4) {
                        Image("upload")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(shoot.author.uploadCount) 图片")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                            .padding(.trailing, 12)
                        Image("saved")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("\(shoot.author.uploadCount) 图片")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                    }
                }
                Spacer()
            }
            
            // 设计模式
            FlowLayout(mode: .vstack,
                       items: shoot.designType,
                       itemSpacing: 4) { text in
                Button {
//                    search = text
                    search = "关注"
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "number")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlue)
                        Text(text)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                    }.padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.shootBlue.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

            }
            
            // 操作按钮
            HStack {
                ActionTitleButtonView(image: "save", title: "收藏") {
                    
                }
                Spacer(minLength: 0)
                ActionTitleButtonView(image: "share", title: "分享") {
                    
                }
                Spacer(minLength: 0)
                ActionTitleButtonView(image: "download", title: "下载") {
                    
                }
                Spacer(minLength: 0)
                ActionTitleButtonView(image: "report", title: "举报") {
                    
                }
            }.padding(.horizontal)
        }.frame(maxWidth: .infinity)
            .padding()
            .padding(.bottom)
            .padding(.top, 8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.shootBlack.opacity(0.2), radius: 10, y: -10)
        .contentShape(Rectangle())
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(shoot: singleShoot)
    }
}
