//
//  BackgroundClearView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/10.
//

import SwiftUI

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_: UIView, context _: Context) {}
}
