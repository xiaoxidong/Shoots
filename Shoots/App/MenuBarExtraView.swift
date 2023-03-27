//
//  MenuBarExtraView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/27.
//

import SwiftUI

struct MenuBarExtraView: View {
    @State var searchText = ""
    var body: some View {
        VStack {
            HStack {
                TextField("搜索应用或设计模式", text: $searchText)
                    .textFieldStyle(.plain)
                Button {
                    
                } label: {
                    Image("self")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }.buttonStyle(.plain)
            }.padding([.horizontal, .top], 12)
            ScrollView(showsIndicators: false) {
                FeedView(shoots: homeData)
            }
        }
        
        
    }
}

struct MenuBarExtraView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarExtraView()
    }
}
