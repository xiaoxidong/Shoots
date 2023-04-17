//
//  UIHostingView.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/4/12.
//

import SwiftUI

final class UIHostingView<Content: View>: UIView {
    private let rootViewHostingController: UIHostingController<Content>

    var rootView: Content {
        get { rootViewHostingController.rootView }
        set {
            rootViewHostingController.rootView = newValue
        }
    }

    required init(rootView: Content) {
        self.rootViewHostingController = UIHostingController(rootView: rootView)
        super.init(frame: .zero)
        rootViewHostingController.view.backgroundColor = .clear
        addSubview(rootViewHostingController.view)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rootViewHostingController.view.frame = bounds
    }

    override func sizeToFit() {
        guard let superview = superview else {
            super.sizeToFit()
            return
        }

        frame.size = rootViewHostingController.sizeThatFits(in: superview.frame.size)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        rootViewHostingController.sizeThatFits(in: size)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        rootViewHostingController.sizeThatFits(in: targetSize)
    }

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        rootViewHostingController.sizeThatFits(in: targetSize)
    }
}
extension View {
    
    public func shadow(
        color: Color = .black,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat
    ) -> some View {
        shadow(color: color, radius: blur / 2, x: x, y: y)
    }
}
