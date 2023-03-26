//
//  FeedView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI
import WaterfallGrid

struct FeedView: View {
    var shoots: [Shoot]
    
    @AppStorage("homeModel") var homeModel = 0
    var body: some View {
        if homeModel == 0 {
            waterfallView(columns: 3)
        } else if homeModel == 1 {
            waterfallView(columns: 2)
        } else {
            singleLineView
        }
    }
    
    func waterfallView(columns: Int) -> some View {
        ScrollView {
            Divider()
            WaterfallGrid(shoots) { shoot in
                ImageCardView(shoot: shoot)
            }
            .gridStyle(columns: columns)
        }
    }
    
    var singleLineView: some View {
        ScrollView {
            Divider()
            VStack(spacing: 2) {
                ForEach(shoots) { shoot in
                    ImageCardView(shoot: shoot)
                        .frame(maxWidth: 560)
                }
            }
        }.background(Color.shootLight.opacity(0.1))
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(shoots: homeData)
    }
}
