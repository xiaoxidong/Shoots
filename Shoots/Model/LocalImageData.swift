//
//  LocalImageData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/22.
//

import SwiftUI

struct LocalImageData: Equatable, Hashable, Codable {
    var image: Data
    var app: String
    var description: String = ""

    var fileName: String
    var fileSuffix: String
    var chooseType: String? = nil
    var picDescription: String = ""
    var tags: [String] = []

    var pattern: String {
        tags.joined(separator: ",")
    }
}
