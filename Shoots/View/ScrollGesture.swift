//
//  ScrollGesture.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/1.
// 首页的手势滑动，向上滑动的时候隐藏导航，向下滑动的时候显示导航，使用 simultaneousGesture 无法很灵活的处理上下滑动
// https://www.youtube.com/watch?v=Q0rb4M6n2ns

import SwiftUI

struct ScrollGesture: UIViewRepresentable {
    var onChange: (UIPanGestureRecognizer) -> Void

    typealias UIViewType = UIView
    private let gestureID = UUID().uuidString

    func makeUIView(context _: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let superView = uiView.superview?.superview, !(superView.gestureRecognizers?.contains(where: { $0.name == gestureID }) ?? false) {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))

                gesture.name = gestureID
                gesture.delegate = context.coordinator
                superView.addGestureRecognizer(gesture)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onChange: onChange)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> Void

        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }

        @objc func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }

        func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
