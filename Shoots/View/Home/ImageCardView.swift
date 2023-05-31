//
//  ImageCardView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import UniformTypeIdentifiers
import StoreKit
import SDWebImageSwiftUI

struct ImageCardView: View {
    var shoot: Picture
    
    @AppStorage("homeModel") var homeModel = 0
    @AppStorage("showReviewAlert") var showReviewAlert = 0
    @State var showDetail: Bool = false
    @Environment(\.requestReview) var requestReview
    let d = "https://shoot-dev.oss-cn-beijing.aliyuncs.com/pics/compress/1663005063778217986/2023/05/31/23e6da9db1044487949bc526819bb121.jpg"
    let da = "https://shoot-dev.oss-cn-beijing.aliyuncs.com/pics/compress/1663005063778217986/2023/05/31/5483214ac3ea48ec8f5e4d8fe8a76c04.jpg"
    var body: some View {
        WebImage(url: URL(string: [d, da].randomElement()!))
            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            .onSuccess { image, data, cacheType in
                // Success
                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
            }
            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
            
            // Supports ViewBuilder as well
            .placeholder {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.1))
                    .overlay {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(.gray.opacity(0.8))
                    }
            }
//            .placeholder(Image(systemName: "photo")) // Placeholder Image
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .scaledToFit()
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
//        #else
//            .draggable(Image(shoot.imageUrl))
        #endif
    }
}

//struct ImageCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageCardView(shoot: singleShoot)
//            .previewDisplayName("Chinese")
//            .environment(\.locale, .init(identifier: "zh-cn"))
//        ImageCardView(shoot: singleShoot)
//            .previewDisplayName("English")
//            .environment(\.locale, .init(identifier: "en"))
//    }
//}
