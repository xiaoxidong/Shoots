//
//  FeedView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI
import WaterfallGrid
import Refresh

struct FeedView: View {
    var shoots: [Picture]
    
    @AppStorage("homeModel") var homeModel = 0
    @State var footerRefreshing = false
    @State var noMore = false
    var body: some View {
        VStack(spacing: 0) {
//            Divider()
            if homeModel == 0 {
                waterfallView(columns: 3)
            } else if homeModel == 1 {
                waterfallView(columns: 2)
            } else {
                singleLineView
            }
        }.background(Color.shootLight.opacity(0.2))
        
        ScrollView {
            // 上拉加载更多
            RefreshFooter(refreshing: $footerRefreshing, action: loadMore) {
                if self.noMore {
                    Text("没有更多内容啦")
                        .foregroundColor(.white)
                } else {
                    Text("加载中...")
                }
            }
            .noMore(noMore)
            .preload(offset: 50)
        }.enableRefresh()
            .refreshable {
                // 下拉刷新
                reload()
            }
    }
    
    func waterfallView(columns: Int) -> some View {
        WaterfallGrid(shoots) { shoot in
            Group {
                if shoot.id == "s" {
                    AddsView()
                } else {
                    ImageCardView(shoot: shoot)
                }
            }
        }
        .gridStyle(columns: columns)
        .gridStyle(spacing: 0)
        .frame(maxWidth: 1060)
    }
    
    var singleLineView: some View {
        VStack(spacing: 2) {
            ForEach(shoots) { shoot in
                ImageCardView(shoot: shoot)
                    .frame(maxWidth: 560)
            }
        }
    }
    
    func loadMore() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            footerRefreshing = false
        }
    }
    
    func reload() {
        
    }
}

//struct FeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedView(shoots: homeData)
//            .previewDisplayName("Chinese")
//            .environment(\.locale, .init(identifier: "zh-cn"))
//        FeedView(shoots: homeData)
//            .previewDisplayName("English")
//            .environment(\.locale, .init(identifier: "en"))
//    }
//}
