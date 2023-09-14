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
            if search.loading {
                LoadingView()
            } else {
                if search.update {
                    patternView(id: id)
                } else {
                    patternView(id: id)
                }
            }
        } else if let name = search.patternName {
            if search.loading {
                LoadingView()
            } else {
                if search.update {
                    patternNameView(name: name)
                } else {
                    patternNameView(name: name)
                }
            }
        }
    }

    func appView(id: String) -> some View {
        AppView(id: id, appID: search.appStoreID)
            .padding(.top)
    }

    func patternView(id: String) -> some View {
        Group {
            if search.patternFeed.isEmpty {
                ShootEmptyView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        FeedView(shoots: search.patternFeed, showBackground: false)

                        LoadMoreView(footerRefreshing: $search.footerRefreshing, noMore: $search.noMore, showBackground: false) {
                            if self.search.page + 1 > self.search.mostPages {
                                self.search.footerRefreshing = false
                                self.search.noMore = true
                            } else {
                                Task {
                                    await search.nextPage(id: id)
                                }
                            }
                        }
                    }.frame(maxWidth: 860)
                        .frame(maxWidth: .infinity)
                        .background(Color.shootLight.opacity(0.06))
                }.enableRefresh()
                    .refreshable {
                        // 首页下拉刷新
                        Task {
                            await search.getPatternPics(id: id)
                        }
                    }
            }
        }
    }

    func patternNameView(name: String) -> some View {
        Group {
            if search.patternFeed.isEmpty {
                ShootEmptyView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        FeedView(shoots: search.patternFeed, showBackground: false)

                        LoadMoreView(footerRefreshing: $search.footerRefreshing, noMore: $search.noMore, showBackground: false) {
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
                    .frame(maxWidth: 860)
                    .frame(maxWidth: .infinity)
                    .background(Color.shootLight.opacity(0.06))
            }
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
            .environmentObject(SearchViewModel())
    }
}
