//
//  CardTapView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/14.
//

import SDWebImageSwiftUI
import StoreKit
import SwiftUI
import UniformTypeIdentifiers

struct CardTapView: View {
    var shoot: Picture

    @AppStorage("homeModel") var homeModel = 0

    var body: some View {
        ImageView(urlString: shoot.compressedPicUrl, image: .constant(nil))
            .overlay(alignment: .topTrailing) {
                Group {
                    if shoot.type != .image {
                        Image(shoot.type.image)
                            .padding(6)
                    }
                }
            }
            .highPriorityGesture(
                TapGesture(count: 2)
                    .onEnded {
                        if homeModel == 0 {
                            homeModel = 1
                        } else if homeModel == 1 {
                            homeModel = 2
                        } else {
                            homeModel = 0
                        }
                    }
            )
    }
}

struct CardTapView_Previews: PreviewProvider {
    static var previews: some View {
        CardTapView(shoot: Picture(id: "", picUrl: ""))
    }
}
