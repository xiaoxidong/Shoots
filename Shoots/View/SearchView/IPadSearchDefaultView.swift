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
    
    let rows = [
            GridItem(.fixed(90.00), spacing: 20),
            GridItem(.fixed(90.00), spacing: 20),
        ]
    @EnvironmentObject var info: InfoViewModel
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .center, spacing: 16) {
                    ForEach(info.apps) { app in
                        Button {
                            searchText = app.linkApplicationName
                        } label: {
                            VStack {
                                Image("Instagram")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 66, height: 66)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                Text(app.linkApplicationName)
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
                       items: info.patterns,
                       itemSpacing: 4) { pattern in
                Button {
                    searchText = pattern.designPatternName
                } label: {
                    HStack(spacing: 2) {
                        Text(pattern.designPatternName)
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
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        IPadSearchDefaultView(searchText: .constant(""))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
