//
//  DetailView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/15.
//

import Refresh
import SwiftUI

struct HomeView: View {
    @Binding var searchText: String
    @Binding var showNavigation: Bool

    @Environment(\.isSearching) var isSearching
    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        @Environment(\.verticalSizeClass) var verticalSizeClass
    #endif
    @StateObject var home: HomeFeedViewModel = .init()
    @State var reachability = Reachability()
    var body: some View {
        ZStack {
            if home.loading {
                LoadingView()
                    .onChange(of: reachability.isConnectedToNetwork(), perform: { newValue in
                        // 第一次打开的时候没有网络授权，授权之后再次请求网络
                        if newValue {
                            loadData()
                        }
                    })
                    .task {
                        loadData()
                    }
            } else {
                feed
            }

            if isSearching || searchText != "" {
                #if os(iOS)
                    if horizontalSizeClass == .compact {
                        SearchView(searchText: $searchText)
                            .onAppear {
                                searching = true
                            }
                            .onDisappear {
                                searching = false
                            }
                    } else {
                        SearchView(searchText: $searchText, showSearchDefault: false)
                    }
                #else
                    SearchView(searchText: $searchText, showSearchDefault: false)
                #endif
            }
        }
    }

    @State var searching = false
    var feed: some View {
        ScrollView {
            VStack(spacing: 0) {
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
            }
        }.enableRefresh()
            .refreshable {
                // 首页下拉刷新
                home.getHomeFirstPageFeed()
            }
            .background {
                ScrollGesture { gesture in
                    if !searching {
                        let offsetY = gesture.translation(in: gesture.view).y
                        let velocityY = gesture.velocity(in: gesture.view).y
                        if velocityY < 0 {
                            // Up
                            if -(velocityY / 5) > 60 && showNavigation {
                                showNavigation = false
                            }
                        } else {
                            // Down
                            if (velocityY / 5) > 40 && !showNavigation {
                                showNavigation = true
                            }
                        }
                    }
                }
            }
        // 下面的办法没有很好的处理向上滑动过程中在向下滑动这种
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
