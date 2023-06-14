//
//  ImageView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/9.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    var urlString: String
    #if os(iOS)
    @Binding var image: UIImage?
    #else
    @Binding var image: NSImage?
    #endif
    
    var body: some View {
        WebImage(url: URL(string: urlString))
            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            .onSuccess { image, data, cacheType in
                self.image = image
                // Success
                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
            }
            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
            .placeholder(Image(systemName: "photo")) // Placeholder Image
            // Supports ViewBuilder as well
            .placeholder {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .scaledToFit()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(urlString: "", image: .constant(nil))
    }
}
