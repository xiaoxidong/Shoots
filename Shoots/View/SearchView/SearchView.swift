//
//  SearchView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

struct SearchView: View {
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
                if searchText == "Instagram" {
                    AppView(app: appData, topPadding: 16)
                } else if searchText == "关注" {
                    FeedView(shoots: homeData)
                } else {
                    SearchDefaultView(searchText: $searchText)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
