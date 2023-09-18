//
//  UnifiedImage.swift
//  Items
//
//  Created by Ian on 27/03/2022.
//

import SwiftUI

#if os(iOS)
import UIKit

public typealias UnifiedImage = UIImage

@available(iOS 13.0, macOS 10.15, *)
extension Image {
    init(unifiedImage: UnifiedImage) {
        self.init(uiImage: unifiedImage)
    }
}
#endif

#if os(macOS)
import AppKit

public typealias UnifiedImage = NSImage

@available(iOS 13.0, macOS 10.15, *)
extension Image {
    init(unifiedImage: UnifiedImage) {
        self.init(nsImage: unifiedImage)
    }
}

extension NSImage {
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: .zero)
    }
}
#endif
