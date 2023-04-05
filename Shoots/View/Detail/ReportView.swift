//
//  ReportView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/4.
//

import SwiftUI

struct ReportView: View {
    var shoot: Shoot
    var body: some View {
        #if os(iOS)
        NavigationView {
            content
                .navigationTitle("报告问题")
        }
        #else
        VStack {
            HStack {
                Text("报告问题")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                MacCloseButton()
            }.padding([.horizontal, .top], 36)
            content
        }
        #endif
    }
    
    @State var text = ""
    @State var type = "包含敏感信息"
    var content: some View {
        ScrollView(showsIndicators: false) {
            Text("问题类型")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)
                .padding(.top, 36)
            Menu {
                Button {
                    type = "所属应用错误"
                } label: {
                    Text("所属应用错误")
                }
                Button {
                    type = "标签错误"
                } label: {
                    Text("标签错误")
                }
                Button {
                    type = "包含黄色信息"
                } label: {
                    Text("包含黄色信息")
                }
                
                Button {
                    type = "包含敏感信息"
                } label: {
                    Text("包含敏感信息")
                }

                    
            } label: {
                Text(type)
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)
            
            Text("问题描述")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 26)
                .padding(.top, 36)
            
            TextEditor(text: $text)
                .padding(.horizontal, 8)
                .frame(height: 260)
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .border(Color.shootLight, width: 0.4)
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 26)
        }.overlay(alignment: .bottom) {
            Button {
                
            } label: {
                HStack {
                    Image("uploadwhite")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 22, height: 22)
                    Text("报告问题")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(LinearGradient(colors: [.yellow, .pink], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .padding(.horizontal, 26)
            }.buttonStyle(.plain)
                .padding(.bottom)
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(shoot: singleShoot)
    }
}