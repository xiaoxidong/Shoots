//
//  ImageCardView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import UniformTypeIdentifiers
import StoreKit

struct ImageCardView: View {
    var shoot: Shoot
    
    @AppStorage("homeModel") var homeModel = 0
    @AppStorage("showReviewAlert") var showReviewAlert = 0
    @State var showDetail: Bool = false
    @Environment(\.requestReview) var requestReview
    var body: some View {
        Image(shoot.imageUrl)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .sheet(isPresented: $showDetail) {
                DetailView(shoot: shoot)
                    .sheetFrameForMac()
            }
            .onTapGesture {
                showDetail.toggle()
                if showReviewAlert < 10 {
                    showReviewAlert += 1
                } else if showReviewAlert == 10 {
                    // 显示引导评价
                    requestReview()
                    showReviewAlert = 11
                }
            }
            .highPriorityGesture (
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
        #if os(macOS)
            .onDrag {
                let fileURL = FileManager.default.homeDirectoryForCurrentUser.appending(component: "cover.png")
                // TODO: 拖拽保存图片
                let image = NSImage(named: "s1")
                FileManager.default.createFile(atPath: fileURL.path, contents: image?.png)
                
                return NSItemProvider(item: fileURL as NSSecureCoding, typeIdentifier: UTType.fileURL.identifier)
            }
        #else
            .draggable(Image(shoot.imageUrl))
        #endif
    }
}

struct ImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardView(shoot: singleShoot)
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        ImageCardView(shoot: singleShoot)
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
