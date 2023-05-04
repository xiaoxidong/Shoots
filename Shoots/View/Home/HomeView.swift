//
//  DetailView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/15.
//

import SwiftUI
import Refresh

struct HomeView: View {
    @ObservedObject var homeVM: HomeViewModel
    @Binding var searchText: String
    
    @Environment(\.isSearching) var isSearching
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    var body: some View {
        if isSearching || searchText != "" {
            #if os(iOS)
            if horizontalSizeClass == .compact {
                if searchText == "Instagram" {
                    AppView(app: appData, topPadding: 16)
                } else if searchText == "关注" {
                    feed
                } else {
                    IOSSearchDefaultView(searchText: $searchText)
                }
            } else {
                if searchText == "Instagram" {
                    AppView(app: appData, topPadding: 16)
                } else if searchText == "关注" {
                    feed
                } else {
                    feed
                }
            }
            #else
            if searchText == "Instagram" {
                AppView(app: appData, topPadding: 16)
            } else if searchText == "关注" {
                feed
            } else {
                feed
            }
            #endif
        } else {
            feed
        }
    }
    
    @State var footerRefreshing = false
    @State var noMore = false
    
    var feed: some View {
        ScrollView {
            FeedView(shoots: homeVM.shoots)
            
            LoadMoreView(footerRefreshing: $footerRefreshing, noMore: $noMore) {
                loadMore()
            }
        }.enableRefresh()
            .refreshable {
                // 首页下拉刷新
                
            }
    }
    
    func loadMore() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            withAnimation(.spring()) {
                footerRefreshing = false
                noMore = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeVM: HomeViewModel(), searchText: .constant(""))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        HomeView(homeVM: HomeViewModel(), searchText: .constant(""))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
