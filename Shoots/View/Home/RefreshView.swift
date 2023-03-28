//
//  RefreshView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/28.
//

import SwiftUI
import Refresh

struct RefreshView: View {
    @State var headerRefreshing = false
    @State var footerRefreshing = false
    @State var noMore = false
    
    var body: some View {
        ScrollView {
            RefreshHeader(refreshing: $headerRefreshing, action: reload) { progress in
                if self.headerRefreshing {
                    Text("refreshing...")
                } else {
                    Text("Pull to refresh")
                }
            }

            ForEach(1...100, id: \.self) { item in
                Text("dddd")
            }

            RefreshFooter(refreshing: $footerRefreshing, action: loadMore) {
                if self.noMore {
                    Text("No more data !")
                } else {
                    Text("refreshing...")
                }
            }
            .noMore(noMore)
            .preload(offset: 50)
        }
        .enableRefresh()
    }
    
    func loadMore() {
        
    }
    
    func reload() {
        
    }
}

struct RefreshView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshView()
    }
}
