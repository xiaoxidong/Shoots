//
//  SearchView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

struct FullScreenSearchView: View {
    @State var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        TextField("输入搜索内容", text: $searchText)
                        Button {
                            dismiss()
                        } label: {
                            Text("取消")
                                .foregroundColor(.shootBlue)
                                .bold()
                        }
                    }.padding(.horizontal)
                    Divider()
                }
                
                // 搜索结果
                SearchView(searchText: $searchText)
            }
        }
    }
}

struct FullScreenSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenSearchView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        FullScreenSearchView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
