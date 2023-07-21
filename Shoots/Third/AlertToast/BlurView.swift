//
//  BlurView.swift
//  AlertToastPreview
//
//  Created by אילי זוברמן on 14/02/2021.
//

import Foundation
import SwiftUI

#if os(macOS)

    @available(macOS 11, *)
    public struct BlurView: NSViewRepresentable {
        public typealias NSViewType = NSVisualEffectView

        public func makeNSView(context _: Context) -> NSVisualEffectView {
            let effectView = NSVisualEffectView()
            effectView.material = .hudWindow
            effectView.blendingMode = .withinWindow
            effectView.state = NSVisualEffectView.State.active
            return effectView
        }

        public func updateNSView(_ nsView: NSVisualEffectView, context _: Context) {
            nsView.material = .hudWindow
            nsView.blendingMode = .withinWindow
        }
    }

#else

    @available(iOS 13, *)
    public struct BlurView: UIViewRepresentable {
        var style: UIBlurEffect.Style = .systemMaterial
        public typealias UIViewType = UIVisualEffectView

        public func makeUIView(context _: Context) -> UIVisualEffectView {
            return UIVisualEffectView(effect: UIBlurEffect(style: style))
            // systemUltraThinMaterialLight
        }

        public func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
            uiView.effect = UIBlurEffect(style: style)
        }
    }

#endif
