//
//  LocalImageData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/22.
//

import SwiftUI

struct LocalImageData: Equatable, Hashable {
    var image: Data
    var app: String
    var pattern: String
    var fileName: String
    var fileSuffix: String
}
