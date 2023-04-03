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
    @AppStorage("showDetailNew") var showDetailNew = true
    var body: some View {
        ScrollView(showsIndicators: false) {
            Image(shoot.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 460)
                .padding(.top)
                .frame(maxWidth: .infinity)
        }.background(Color.shootLight.opacity(0.1))
        .overlay(alignment: .bottom) {
            infoView
                .offset(y: showDetail ? 0 : 1000)
        }
        .overlay(alignment: .bottom) {
            saveView
                .offset(y: showSave ? 0 : 1000)
        }
        .overlay(
            Group {
                Color.black.opacity(showDetailNew ? 0.4 : 0)
                VStack(spacing: 16) {
                    Image("doubleclick")
                    Text("点击查看截图详情信息")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Button {
                        withAnimation(.spring()) {
                            showDetailNew.toggle()
                        }
                    } label: {
                        Text("知道了")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 56)
                            .padding(.vertical, 12)
                            .background(LinearGradient(colors: [.pink, .yellow], startPoint: .leading, endPoint: .trailing))
                            .clipShape(Capsule())
                    }.padding(.top)
                }.opacity(showDetailNew ? 1 : 0)
            }
        )
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation(.spring()) {
                showDetail.toggle()
            }
        }
        #if os(iOS)
        .fullScreenCover(item: $search) { search in
            SearchView(searchText: search)
        }
        #else
        .overlay(alignment: .topTrailing) {
            MacCloseButton()
                .padding(26)
        }
        #endif
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
            }.buttonStyle(.plain)
                .sheet(isPresented: $showApp) {
                    #if os(iOS)
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
                    #else
                    VStack {
                        HStack {
                            Text("Instagram")
                                .font(.largeTitle)
                                .bold()
                            Spacer()
                            MacCloseButton()
                        }.padding([.horizontal, .top], 36)
                        AppView(app: shoot.app)
                    }.sheetFrameForMac()
                    #endif
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
                }.buttonStyle(.plain)
            }
            
            // 操作按钮
            HStack {
                ActionTitleButtonView(image: "save", title: "收藏") {
                    #if os(iOS)
                    FeedbackManager.impact(style: .medium)
                    #endif
                    withAnimation(.spring()) {
                        showDetail = false
                        showSave = true
                    }
                }
                Spacer(minLength: 0)
                
                ShareLink(item: Image(shoot.imageUrl), preview: SharePreview("Shoots", image: Image(shoot.imageUrl))) {
                    VStack {
                        Image("share")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("分享")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                    }
                }
                
                Spacer(minLength: 0)
                ActionTitleButtonView(image: "download", title: "下载") {
                    #if os(iOS)
                    FeedbackManager.impact(style: .medium)
                    #endif
                    
                    let imageSaver = ImageSaver()
                    imageSaver.successHandler = {
                        print("保存成功")
                    }
                    imageSaver.errorHandler = {
                        print("保存失败: \($0.localizedDescription)")
                    }
                    imageSaver.writeToPhotoAlbum(image: UIImage(named: shoot.imageUrl)!)
                }
                Spacer(minLength: 0)
                ActionTitleButtonView(image: "report", title: "举报") {
                    
                }
            }.padding(.horizontal)
        }.frame(maxWidth: 460)
            .padding()
            .padding(.bottom)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.shootBlack.opacity(0.2), radius: 10, y: -10)
        .contentShape(Rectangle())
    }
    
    @State var showSave = false
    var saveView: some View {
        VStack {
            ZStack {
                Text("添加收藏夹")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.shootBlack)
                Button {
                    
                } label: {
                    Image("add")
                }.padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 26) {
                    FolderCardView(images: ["s1", "s2", "s4"], name: "Ins")
                    FolderCardView(images: ["s5", "s6", "s9"], name: "Ins")
                    FolderCardView(images: ["s8", "s3", "s1"], name: "Ins")
                }.padding(.horizontal, 26)
            }
        }.frame(maxWidth: 460)
            .padding(.vertical)
            .padding(.bottom)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
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
