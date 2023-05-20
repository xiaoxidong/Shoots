//
//  DetailView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/15.
//

import SwiftUI
import Refresh

struct HomeView: View {
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
                if searchText != "" {
                    AppView(app: appData, topPadding: 16)
                } else {
                    IOSSearchDefaultView(searchText: $searchText)
                }
            } else {
                if searchText != "" {
                    AppView(app: appData, topPadding: 16)
                } else {
                    feed
                }
            }
            #else
            if searchText != "" {
                AppView(app: appData, topPadding: 16)
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
    
    @EnvironmentObject var user: UserViewModel
    var feed: some View {
        ScrollView {
            FeedView(shoots: user.homeFeed)
            
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
        HomeView(searchText: .constant(""))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
            .environmentObject(UserViewModel())
            .environmentObject(HomeViewModel())
        HomeView(searchText: .constant(""))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(UserViewModel())
            .environmentObject(HomeViewModel())
    }
}
