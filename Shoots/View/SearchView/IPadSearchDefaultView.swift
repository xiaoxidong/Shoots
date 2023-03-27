//
//  IPadSearchDefaultView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/26.
//

import SwiftUI
import SwiftUIFlowLayout

struct IPadSearchDefaultView: View {
    @Binding var searchText: String
    
    @State var tagTexts: [String] = ["关注", "设置", "粉丝", "信息流", "自定义内容", "卡片", "用户中心", "推荐", "Setting"]
    let rows = [
            GridItem(.fixed(90.00), spacing: 20),
            GridItem(.fixed(90.00), spacing: 20),
        ]
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .center, spacing: 16) {
                    ForEach(apps) { app in
                        Button {
                            searchText = app.name
                        } label: {
                            VStack {
                                Image(app.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 66, height: 66)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                Text(app.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.shootBlack)
                            }
                        }.buttonStyle(.plain)
                    }
                }.padding(.horizontal)
                    .padding(.top)
            }
            
            // Tag
            FlowLayout(mode: .vstack,
                       items: tagTexts,
                       itemSpacing: 4) { text in
                Button {
                    searchText = text
                } label: {
                    HStack(spacing: 2) {
                        Text(text)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                    }.padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.shootBlue.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }.buttonStyle(.plain)
            }.padding(.top)
                .padding(.horizontal)
        }
    }
}

struct IPadSearchDefaultView_Previews: PreviewProvider {
    static var previews: some View {
        IPadSearchDefaultView(searchText: .constant(""))
    }
}
