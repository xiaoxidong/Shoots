//
//  DetailView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/15.
//

import SwiftUI
import WaterfallGrid

struct HomeView: View {
    @ObservedObject var homeVM: HomeViewModel
    
    @AppStorage("homeModel") var homeModel = 0
    @Environment(\.isSearching) var isSearching
    var body: some View {
        if isSearching {
            SearchView()
        } else {
            if homeModel == 0 {
                waterfallView(columns: 3)
            } else if homeModel == 1 {
                waterfallView(columns: 2)
            } else {
                singleLineView
            }
        }
    }
    
    func waterfallView(columns: Int) -> some View {
        ScrollView {
            Divider()
            WaterfallGrid(homeVM.shoots) { shoot in
                ImageCardView(shoot: shoot)
            }
            .gridStyle(columns: columns)
        }
    }
    
    var singleLineView: some View {
        ScrollView {
            Divider()
            VStack(spacing: 2) {
                ForEach(homeVM.shoots) { shoot in
                    ImageCardView(shoot: shoot)
                }
            }
        }.background(Color.shootLight.opacity(0.1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeVM: HomeViewModel())
    }
}
