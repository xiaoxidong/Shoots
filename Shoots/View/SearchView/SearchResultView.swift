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
            if search.update {
                appView(id: id)
            } else {
                appView(id: id)
            }
        } else if let id = search.patternID {
            if search.update {
                patternView(id: id)
            } else {
                patternView(id: id)
            }
        } else if let name = search.patternName {
            ScrollView {
                VStack(spacing: 0) {
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

    func appView(id: String) -> some View {
        AppView(id: id, appID: search.appStoreID)
            .frame(maxWidth: 860)
            .frame(maxWidth: .infinity)
            .padding(.top)
    }

    func patternView(id: String) -> some View {
        ScrollView {
            VStack(spacing: 0) {
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
            }
        }.enableRefresh()
            .refreshable {
                // 首页下拉刷新
                Task {
                    await search.getPatternPics(id: id)
                }
            }
            .frame(maxWidth: 1060)
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
    }
}
