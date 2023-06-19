//
//  SearchResultView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/15.
//

import SwiftUI

struct SearchResultView: View {
    
    @EnvironmentObject var search: SearchViewModel
    var body: some View {
        if let id = search.appID {
            AppView(id: id)
                .frame(maxWidth: 1060)
        } else if let id = search.patternID {
            ScrollView {
                FeedView(shoots: search.patternFeed)
                
                LoadMoreView(footerRefreshing: $search.footerRefreshing, noMore: $search.noMore) {
                    if self.search.page + 1 > self.search.mostPages {
                        self.search.footerRefreshing = false
                        self.search.noMore = true
                    } else {
                        Task {
                            await search.nextPage(id: id)
                        }
                    }
                }
            }.enableRefresh()
                .refreshable {
                    // 首页下拉刷新
                    Task {
                        await search.getPatternPics(id: id)
                    }
                }
                .frame(maxWidth: 1060)
        } else if let name = search.patternName {
            ScrollView {
                FeedView(shoots: search.patternFeed)
                
                LoadMoreView(footerRefreshing: $search.footerRefreshing, noMore: $search.noMore) {
                    if self.search.page + 1 > self.search.mostPages {
                        self.search.footerRefreshing = false
                        self.search.noMore = true
                    } else {
                        Task {
                            await search.nextPatternNamePage(name: name)
                        }
                    }
                }
            }.enableRefresh()
                .refreshable {
                    // 首页下拉刷新
                    Task {
                        await search.getPatternNamePics(name: name)
                    }
                }
                .frame(maxWidth: 1060)
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
    }
}
