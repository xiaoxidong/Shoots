//
//  ZLImageEditorLayout.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/4/23.
//

import UIKit

struct ZLImageEditorLayout {
    static let bottomToolBtnH: CGFloat = 34

    static let bottomToolTitleFont = UIFont.systemFont(ofSize: 17)

    static let bottomToolBtnCornerRadius: CGFloat = 5
}

func zlRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
    return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
}

func getImage(_ named: String) -> UIImage? {
    if ZLCustomImageDeploy.imageNames.contains(named), let image = UIImage(named: named) {
        return image
    }
    if let image = ZLCustomImageDeploy.imageForKey[named] {
        return image
    }
    return UIImage(named: named, in: Bundle.zlImageEditorBundle, compatibleWith: nil)
}

func deviceSafeAreaInsets() -> UIEdgeInsets {
    var insets: UIEdgeInsets = .zero

    if #available(iOS 11, *) {
//        insets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }

    return insets
}

func zl_debugPrint(_: Any) {
//    debugPrint(message)
}
