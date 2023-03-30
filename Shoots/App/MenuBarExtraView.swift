//
//  MenuBarExtraView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/27.
//

import SwiftUI
import Refresh

struct MenuBarExtraView: View {
    @Binding var isInserted: Bool
    @Binding var isMenuPresented: Bool
    
    @State var searchText = ""
    @Environment(\.openWindow) var openWindow
    var body: some View {
        VStack {
            HStack {
                TextField("搜索应用或设计模式", text: $searchText)
                    .textFieldStyle(.plain)
                Button {
                    isMenuPresented.toggle()

                    if #available(macOS 13, *) {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    } else {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                    }
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Image("setting")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color.shootBlack)
                        .padding(4)
                        .contentShape(Rectangle())
                }.buttonStyle(.plain)
                
                Button {
//                    NSApp.setActivationPolicy(.regular)
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
            
            feed
        }
    }
    
    @State var footerRefreshing = false
    @State var noMore = false
    
    var feed: some View {
        ScrollView {
            FeedView(shoots: homeData)
            
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

struct MenuBarExtraView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarExtraView(isInserted: .constant(false), isMenuPresented: .constant(false))
    }
}
