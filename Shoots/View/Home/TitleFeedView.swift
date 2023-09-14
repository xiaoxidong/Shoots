//
//  TitleFeedView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/12.
//

import Grid
import Refresh
import SwiftUI
import WaterfallGrid

struct TitleFeedView: View {
    var shoots: [Picture]
    var showBackground: Bool = true

    @AppStorage("homeModel") var homeModel = 0
    @State var footerRefreshing = false
    @State var noMore = false
    var body: some View {
        LazyVStack(spacing: 0) {
            if homeModel == 0 {
                waterfallView(columns: 3)
            } else if homeModel == 1 {
                waterfallView(columns: 2)
            } else {
                singleLineView
            }
        }.background(showBackground ? Color.shootLight.opacity(0.06) : .clear)
    }

    @ViewBuilder
    func waterfallView(columns: Int) -> some View {
        if shoots.count < 4 {
            HStack(spacing: 8) {
                ForEach(shoots) { shoot in
//                    ImageCardView(shoot: shoot)
                    Image(shoot.picUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 160)
                }
                Spacer(minLength: 0)
            }.padding(.horizontal, 8)
        } else {
            Grid(shoots) { shoot in
                Group {
                    if shoot.id == "s" {
                        AddsView()
                    } else {
//                        ImageCardView(shoot: shoot)
                        VStack {
                            Image(shoot.picUrl)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text(shoot.id)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.shootBlack)
                                .lineLimit(2)
                                .frame(height: 56)
                        }
                    }
                }
            }.gridStyle(StaggeredGridStyle(tracks: .count(columns)))
                .frame(maxWidth: 1060)
        }

//        WaterfallGrid(shoots) { shoot in
//            Group {
//                if shoot.id == "s" {
//                    AddsView()
//                } else {
//                    ImageCardView(shoot: shoot)
//                }
//            }
//        }
//        .gridStyle(columns: columns)
//        .gridStyle(spacing: 0)
//        .frame(maxWidth: 1060)
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

    func reload() {}
}

struct TitleFeedView_Previews: PreviewProvider {
    static var previews: some View {
        TitleFeedView(shoots: pic)
    }
}

var pic: [Picture] = [
    Picture(id: "Many of the links above are affiliate links. This means that I earn a small commission if you purchase the plugins or sign up for a subscription. It won't cost you any more but it helps me to keep making these tutorial videos for free.", picUrl: "s1"),
    Picture(id: "Add your video to a circle in Final Cut Pro using only the built-in plugins.", picUrl: "s2"),
    Picture(id: "Starting in iOS 15, the background materials for bars (navigation bar, tab bar, etc.) were removed giving more visual clarity to your content as stated in this WWDC 2021 video titled What's new in UIKit", picUrl: "s3"),
    Picture(id: "When you set a background color, you will notice it will go behind the NavigationView for large and inline nav bars.", picUrl: "s4"),
    Picture(id: "The background of a view, such as shape styles, will automatically expand into the safe areas it touches.", picUrl: "s5"),
    Picture(id: "There is a new initializer introduced with iOS 15 that allows backgrounds to expand into safe areas. You could manually set the safe area edge but by default, it is set to all edges.", picUrl: "s6"),
    Picture(id: "That Rectangle with the background HAS to touch the safe area edge.", picUrl: "s7"),
    Picture(id: "The shape style (Color) is in a background modifier because the background accepts a ShapeStyle type.", picUrl: "s8"),
    Picture(id: "The background touching the safe area edge should be the full width of the NavigationStack. The Rectangle shape expands horizontally to match the width of the device/NavigationStack.", picUrl: "s9"),
    Picture(id: "The background touching the safe area edge should be the full width of the NavigationStack. The Rectangle shape expands horizontally to match the width of the device/NavigationStack.", picUrl: "s10")
]
