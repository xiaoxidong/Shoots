//
//  SelectionFeedView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/14.
//

import Grid
import Refresh
import SwiftUI
import WaterfallGrid

struct SelectionFeedView: View {
    var shoots: [Picture]
    var showBackground: Bool = true
    let action: (Picture) -> Void

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
                    CardTapView(shoot: shoot)
                        .frame(maxWidth: 160)
                        .onTapGesture {
                            action(shoot)
                        }
                }
                Spacer(minLength: 0)
            }.padding(.horizontal, 8)
        } else {
            Grid(shoots) { shoot in
                CardTapView(shoot: shoot)
                    .onTapGesture {
                        action(shoot)
                    }
            }.gridStyle(StaggeredGridStyle(tracks: .count(columns)))
                .frame(maxWidth: 1060)
        }
    }

    var singleLineView: some View {
        VStack(spacing: 2) {
            ForEach(shoots) { shoot in
                CardTapView(shoot: shoot)
                    .frame(maxWidth: 560)
                    .onTapGesture {
                        action(shoot)
                    }
            }
        }
    }
}

struct SelectionFeedView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionFeedView(shoots: [Picture(id: "", picUrl: "", chooseType: "")]) { shoot in
            print("----")
        }
    }
}
