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
    
    @StateObject var home: HomeFeedViewModel = HomeFeedViewModel()
    var body: some View {
        if isSearching || searchText != "" {
            #if os(iOS)
            if horizontalSizeClass == .compact {
                if searchText != "" {
                    AppView(id: "appData", topPadding: 16)
                } else {
                    IOSSearchDefaultView(searchText: $searchText)
                }
            } else {
                if searchText != "" {
                    AppView(id: "appData", topPadding: 16)
                } else {
                    feed
                }
            }
            #else
            if searchText != "" {
                AppView(id: "appData", topPadding: 16)
            } else {
                feed
            }
            #endif
        } else {
            feed
        }
    }
    
    var feed: some View {
        ScrollView {
            FeedView(shoots: home.homeFeed)
            
            LoadMoreView(footerRefreshing: $home.footerRefreshing, noMore: $home.noMore) {
                Task {
                    await home.nextPage()
                }
            }
        }.enableRefresh()
            .refreshable {
                // 首页下拉刷新
                loadData()
            }
            .onChange(of: Reachability.isConnectedToNetwork(), perform: { newValue in
                // 第一次打开的时候没有网络授权，授权之后再次请求网络
                if newValue {
                    loadData()
                }
            })
            .onAppear {
                loadData()
            }
    }
    
    func loadData() {
        home.getHomeFirstPageFeed()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(searchText: .constant(""))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
            .environmentObject(UserViewModel())
        HomeView(searchText: .constant(""))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(UserViewModel())
    }
}
