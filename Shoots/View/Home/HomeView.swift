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
    var body: some View {
        if isSearching {
            if searchText == "Instagram" {
                AppView(app: appData, topPadding: 16)
            } else if searchText == "关注" {
                FeedView(shoots: homeData)
            } else {
                SearchView(searchText: $searchText)
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
