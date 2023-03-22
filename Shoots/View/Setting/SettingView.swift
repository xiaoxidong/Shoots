//
//  SettingView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct SettingView: View {
    @State var showPro = false
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Group {
                    SettingCellView(image: "pro", text: "Shoots Pro") {
                        showPro.toggle()
                    }
                    
                    // 基础设置
                    Text("基础设置")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.top, 36)
                    SettingCellView(image: "mode", text: "外观设置") {
                        
                    }
                    SettingCellView(image: "appicon", text: "应用图标") {
                        
                    }
                }
                
                Group {
                    Text("支持我们")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.top, 36)
                    SettingCellView(image: "shareapp", text: "分享给好友") {
                        
                    }
                    SettingCellView(image: "rate", text: "给我们一个五星评价") {
                        
                    }
                    SettingCellView(image: "feedback", text: "问题反馈") {
                        
                    }
                    SettingCellView(image: "weibo", text: "新浪微博") {
                        
                    }
                    
                    
                    Text("隐私协议")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.shootGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.top, 36)
                    SettingCellView(image: "yinsi", text: "用户隐私") {
                        
                    }
                    SettingCellView(image: "xieyi", text: "使用协议") {
                        
                    }
                }
                
                Text("🎈A YUANXIAODONG PRODUCT MADE WITH ♥️")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.gray)
                    .padding(.top, 86)
                    .padding(.bottom, 26)
            }
        }
        .navigationTitle("设置")
        .sheet(isPresented: $showPro) {
            ProView()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
        }
    }
}
