//
//  SheetSearchView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

struct SheetSearchView: View {
    @State var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .padding(.leading, 4)
                                .foregroundColor(.gray)
                            TextField("搜索应用或设计模式", text: $searchText)
                        }.padding(.vertical, 6)
                            .background(.gray.opacity(0.16), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        Button {
                            dismiss()
                        } label: {
                            Text("取消")
                                .foregroundColor(.shootBlue)
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

struct SheetSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SheetSearchView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
            .environmentObject(InfoViewModel())
            .environmentObject(SearchViewModel())
        SheetSearchView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(InfoViewModel())
            .environmentObject(SearchViewModel())
    }
}
