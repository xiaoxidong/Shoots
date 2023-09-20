//
//  LocalImageData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/22.
//

import SwiftUI

struct LocalImageData: Equatable, Hashable, Codable, Identifiable {
    var id = UUID()
    var image: Data
    var app: String

    var fileName: String
    var fileSuffix: String
    var chooseType: ImageType = .image
    var picDescription: String = ""
    var linkedPicId: String = ""
    var tags: [String] = []

    var pattern: String {
        tags.joined(separator: ",")
    }
}
