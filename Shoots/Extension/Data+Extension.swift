//
//  Data+Extension.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/27.
//

import SwiftUI

extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [.compressionFactor: 1])}
}

extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}

extension NSImage {
    var png: Data? { tiffRepresentation?.bitmap?.png }
}
