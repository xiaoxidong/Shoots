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
    @Binding var showNavigation: Bool
    
    @Environment(\.isSearching) var isSearching
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    @StateObject var home: HomeFeedViewModel = HomeFeedViewModel()
    @State var reachability = Reachability()
    var body: some View {
        ZStack {
            feed
            if isSearching || searchText != "" {
                #if os(iOS)
                if horizontalSizeClass == .compact {
                    SearchView(searchText: $searchText)
                } else {
                    SearchView(searchText: $searchText, showSearchDefault: false)
                }
                #else
                SearchView(searchText: $searchText, showSearchDefault: false)
                #endif
            }
        }
    }
    
    var feed: some View {
        ScrollView {
            FeedView(shoots: home.homeFeed)
            
            LoadMoreView(footerRefreshing: $home.footerRefreshing, noMore: $home.noMore) {
                if self.home.page + 1 > self.home.mostPages {
                    self.home.footerRefreshing = false
                    self.home.noMore = true
                } else {
                    Task {
                        await home.nextPage()
                    }
                }
            }
        }.enableRefresh()
            .refreshable {
                // 首页下拉刷新
                home.getHomeFirstPageFeed()
            }
//            .simultaneousGesture(
//                DragGesture()
//                    .onChanged({ location in
//                        print(location.translation.height)
//                        if location.translation.height > 0 {
//                            print("下")
//                            withAnimation(.spring()) {
//                                showNavigation = true
//                            }
//                        } else {
//                            print("上")
//                            withAnimation(.spring()) {
//                                showNavigation = false
//                            }
//                        }
//                    })
//            )
            .onChange(of: reachability.isConnectedToNetwork(), perform: { newValue in
                // 第一次打开的时候没有网络授权，授权之后再次请求网络
                if newValue {
                    loadData()
                }
            })
            .task {
                loadData()
            }
    }
    
    func loadData() {
        if home.homeFeed.isEmpty {
            home.getHomeFirstPageFeed()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(searchText: .constant(""), showNavigation: .constant(true))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
            .environmentObject(UserViewModel())
        HomeView(searchText: .constant(""), showNavigation: .constant(true))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(UserViewModel())
    }
}
