//
//  UploadView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

struct UploadView: View {
    @State var selection: Int = 0
    @Environment(\.dismiss) var dismiss
    var body: some View {
        TabView(selection: $selection) {
            Image("s1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: screen.width, height: screen.height)
                .ignoresSafeArea()
                .tag(0)
            Image("s2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: screen.width, height: screen.height)
                
                .tag(1)
            Image("s3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: screen.width, height: screen.height)
                .ignoresSafeArea()
                .tag(2)
            Image("s4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: screen.width, height: screen.height)
                .ignoresSafeArea()
                .tag(3)
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar(.hidden, for: .navigationBar)
        .edgesIgnoringSafeArea(.all)
        
        .safeAreaInset(edge: .top) {
            topActions
        }
        .safeAreaInset(edge: .bottom) {
            bottomActions
        }
    }
    
    var topActions: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(12)
                        .tint(.shootBlue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .shootBlack.opacity(0.2), x: 0, y: 0, blur: 12)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
                TitlePageControll(progress: selection, numberOfPages: 3, tintColor: UIColor(Color.shootLight), currentPageTintColor: UIColor(Color.shootBlue))
                    .frame(height: 24)
                Spacer(minLength: 0)
                Button {
                    dismiss()
                    //TODO: 后台上传截图
                    
                } label: {
                    Text("上传")
                        .font(.system(size: 14, weight: .semibold))
                        .tint(.shootBlue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(color: .shootBlack.opacity(0.2), x: 0, y: 0, blur: 12)
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.padding(.horizontal)
            Divider()
        }.background(Color.white)
    }
    
    @State var appText = ""
    @State var tagText = ""
    @State var showBluer = false
    @State var showCombine = false
    var bottomActions: some View {
        VStack(spacing: 12) {
            Divider()
            
            HStack(spacing: 16) {
                TextField("应用名称", text: $appText)
                    .frame(width: 106)
                Divider().frame(height: 36)
                TextField("设计模式", text: $tagText)
                Button {
                    showBluer.toggle()
                } label: {
                    Image("blur")
                }
               
                Button {
                    showCombine.toggle()
                } label: {
                    Image("connect")
                }
            }.padding(.horizontal)
        }.background(Color.white)
            .shadow(color: Color.shootBlack.opacity(0.06), x: 0, y: -6, blur: 10)
            .fullScreenCover(isPresented: $showBluer) {
                ShootBlurView()
            }
            .fullScreenCover(isPresented: $showCombine) {
                CombineSelectView()
            }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UploadView()
        }
    }
}
