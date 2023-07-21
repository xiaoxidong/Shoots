//
//  AppIconView.swift
//  Shoots_Mac
//
//  Created by XiaoDong Yuan on 2023/4/3.
//

import SwiftUI

struct AppIconView: View {
    var appIconBackside: Image? = nil
    var appIconFrontside: Image? = nil

    @State private var iconHover: Bool = false
    @State private var foregroundIconVisible: Bool = true
    @State private var backgroundIconVisible: Bool = false
    var body: some View {
        ZStack {
            // App Icon: Back
            Group {
                if let backside = self.appIconBackside {
                    backside.resizable()
                } else {
                    AppIconPlaceholder()
                }
            }
            .rotation3DEffect(self.backgroundIconVisible ? Angle.zero : Angle(degrees: -90.0),
                              axis: (x: 0.0, y: 1.0, z: 0.0),
                              anchor: .center,
                              anchorZ: 0.0,
                              perspective: -0.5)

            // App Icon: Front
            Group {
                if let appIcon = appIconFrontside {
                    appIcon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    AppIconPlaceholder()
                }
            }
            .rotation3DEffect(self.foregroundIconVisible ? Angle.zero : Angle(degrees: 90.0),
                              axis: (x: 0.0, y: 1.0, z: 0.0),
                              anchor: .center,
                              anchorZ: 0.0,
                              perspective: -0.5)
        }
        .frame(width: 128.0, height: 128.0)
        .brightness(self.iconHover ? 0.05 : 0.0)
        .onHover(perform: {
            state in

            let ani = Animation.easeInOut(duration: 0.16)
            withAnimation(ani) {
                self.iconHover = state
            }

            if !state, self.backgroundIconVisible {
                self.flipIcon()
            }

        })
        .onTapGesture(perform: {
            self.flipIcon()
        })
    }

    private func flipIcon() {
        let reversed = foregroundIconVisible

        let inDuration = 0.12
        let inAnimation = Animation.easeIn(duration: inDuration)
        let outAnimation = Animation.easeOut(duration: 0.32)

        withAnimation(inAnimation) {
            if reversed {
                self.foregroundIconVisible.toggle()
            } else {
                self.backgroundIconVisible.toggle()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + inDuration) {
            withAnimation(outAnimation) {
                if !reversed {
                    self.foregroundIconVisible.toggle()
                } else {
                    self.backgroundIconVisible.toggle()
                }
            }
        }
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))

        AppIconView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
