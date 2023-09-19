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
    @FocusState var focused: Bool
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            // 搜索结果
            SearchView(searchText: $searchText, showSearchBackground: false)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 12))
                                    .foregroundColor(.shootGray)
                                TextField("搜索应用或设计模式", text: $searchText)
                                    .focused($focused)
                            }.padding(.vertical, 6)
//                                .background(.gray.opacity(0.16), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Button {
                                dismiss()
                            } label: {
                                Text("取消")
                                    .foregroundColor(.shootBlue)
                                    .bold()
                            }
                        }
                    }
                }
        }.onAppear {
            focused = true
        }
        #else
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 12))
                        .foregroundColor(.shootGray)
                    TextField("搜索应用或设计模式", text: $searchText)
                        .focused($focused)
                }.padding(.vertical, 6)
//                                .background(.gray.opacity(0.16), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                Button {
                    dismiss()
                } label: {
                    Text("取消")
                        .foregroundColor(.shootBlue)
                        .bold()
                }
            }
            
            SearchView(searchText: $searchText, showSearchBackground: false)
        }
        #endif
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
