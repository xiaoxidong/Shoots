//
//  ImageView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/9.
//

import SDWebImageSwiftUI
import SwiftUI

struct ImageView: View {
    var urlString: String
    var isGif: Bool = false
    #if os(iOS)
    @Binding var image: UIImage?
    #else
    @Binding var image: NSImage?
    #endif

    @State var isAnimating = true
    @EnvironmentObject var user: UserViewModel
    var body: some View {
        WebImage(url: URL(string: urlString), isAnimating: $isAnimating)
            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            .onSuccess { image, _, _ in
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
            .overlay(
                Group {
                    if isGif && !isAnimating {
                        Button {
                            freeClick()
                        } label: {
                            Image("play")
                                .shadow(color: Color.shootBlack.opacity(0.1), radius: 6, x: 0, y: 4)
                        }.buttonStyle(.plain)
                            .padding(.bottom, 56)
                    }
                }
            )
            .onAppear {
                if !user.isPro {
                    withAnimation(.spring()) {
                        isAnimating = false
                    }
                }
            }
    }
    
    @AppStorage("dayFree") var dayFree: Int = 0
    @State var showPro = false
    func freeClick() {
        if let date = Defaults().get(for: .day) {
            if dayFree < 5 {
                withAnimation(.spring()) {
                    isAnimating = true
                }
                dayFree += 1
            } else {
                showPro = true
            }
        } else {
            Defaults().set(Date(), for: .day)
            withAnimation(.spring()) {
                isAnimating = true
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(urlString: "", isGif: true, image: .constant(nil))
    }
}
