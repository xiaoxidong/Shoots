//
//  FlowView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

struct FlowView: View {
    var flow: Flow
    
    @Environment(\.dismiss) var dismiss
    @State var showDetail = false
    var screen = UIScreen.main.bounds
    var body: some View {
        TabView {
            ForEach(flow.images, id: \.self) { image in
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                // 不设置的时候，左侧有个空白
                    .frame(width: screen.width, height: screen.height)
            }
        }.tabViewStyle(.page)
            .navigationBarBackButtonHidden()
            .statusBarHidden()
            .onTapGesture {
                withAnimation(.spring()) {
                    showDetail.toggle()
                }
            }
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 12)
                        .padding()
                        .padding(.top)
                }.tint(.shootBlack)
            }
            .overlay(alignment: .bottom) {
                infoView
                    .offset(y: showDetail ? 0 : 1000)
            }
            .ignoresSafeArea()
    }
    
    var infoView: some View {
        VStack(spacing: 16) {
            Text("关于操作集")
            // 顶部应用按钮
            Text(flow.description)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.shootBlack)
                .lineSpacing(4)
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

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView(flow: flow)
    }
}
