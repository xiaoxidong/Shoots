//
//  File.swift
//
//
//  Created by אילי זוברמן on 14/02/2021.
//

import SwiftUI

#if os(macOS)
    @available(macOS 11, *)
    struct AlertActivityIndicatorView: NSViewRepresentable {
        func makeNSView(context: NSViewRepresentableContext<AlertActivityIndicatorView>) -> NSProgressIndicator {
            let nsView = NSProgressIndicator()

            nsView.isIndeterminate = true
            nsView.style = .spinning
            nsView.startAnimation(context)

            return nsView
        }

        func updateNSView(_: NSProgressIndicator, context _: NSViewRepresentableContext<AlertActivityIndicatorView>) {}
    }
#else
    @available(iOS 13, *)
    struct AlertActivityIndicatorView: UIViewRepresentable {
        func makeUIView(context _: UIViewRepresentableContext<AlertActivityIndicatorView>) -> UIActivityIndicatorView {
            let progressView = UIActivityIndicatorView(style: .large)
            progressView.startAnimating()

            return progressView
        }

        func updateUIView(_: UIActivityIndicatorView, context _: UIViewRepresentableContext<AlertActivityIndicatorView>) {}
    }
#endif
