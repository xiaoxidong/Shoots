//
//  MenuBarExtraView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/27.
//

import Refresh
import SwiftUI

struct MenuBarExtraView: View {
    @Binding var isInserted: Bool
    @Binding var isMenuPresented: Bool

    @State var searchText = ""
    @Environment(\.openWindow) var openWindow
    @AppStorage("showAI") var showAI = true
    @StateObject var home: HomeFeedViewModel = .init()

    var body: some View {
        VStack {
            HStack {
                TextField("搜索应用或设计模式(􀆍 + 􀆔 + S)", text: $searchText)
                    .textFieldStyle(.plain)
                Button {
                    NSApp.setActivationPolicy(.regular)
                    isMenuPresented.toggle()

                    if #available(macOS 13, *) {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    } else {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                    }
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Group {
                        if showAI {
                            Image(systemName: "theatermask.and.paintbrush.fill")
                                .font(.system(size: 16))
                        } else {
                            Image("setting")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                        }
                    }
                    .foregroundColor(Color.shootBlack)
                    .padding(4)
                    .contentShape(Rectangle())
                }.buttonStyle(.plain)

                Button {
                    NSApp.setActivationPolicy(.regular)
                    isMenuPresented.toggle()
                    openWindow(id: "main")
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Image("inwindow")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.shootBlack)
                        .padding(4)
                        .contentShape(Rectangle())
                }.buttonStyle(.plain)
            }.padding([.horizontal, .top], 14)

            ZStack {
                feed
                SearchView(searchText: $searchText, showSearchDefault: false)
            }
        }.onAppear {
            load()
        }
    }

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
                load()
            }
    }

    func load() {
        home.getHomeFirstPageFeed()
    }
}

struct MenuBarExtraView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarExtraView(isInserted: .constant(false), isMenuPresented: .constant(false))
    }
}
