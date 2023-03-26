//
//  DetailView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/15.
//

import SwiftUI

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
            if horizontalSizeClass == .compact {
                if searchText == "Instagram" {
                    AppView(app: appData, topPadding: 16)
                } else if searchText == "关注" {
                    FeedView(shoots: homeData)
                } else {
                    IOSSearchDefaultView(searchText: $searchText)
                }
            } else {
                if searchText == "Instagram" {
                    AppView(app: appData, topPadding: 16)
                } else if searchText == "关注" {
                    FeedView(shoots: homeData)
                } else {
                    FeedView(shoots: homeVM.shoots)
                }
            }
        } else {
            FeedView(shoots: homeVM.shoots)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeVM: HomeViewModel(), searchText: .constant(""))
    }
}
