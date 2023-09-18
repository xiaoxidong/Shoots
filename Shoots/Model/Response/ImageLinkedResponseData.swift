//
//  ImageLinkedResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/18.
//

import SwiftUI

struct ImageLinkedResponseData: Codable {
    var code: Int
    var msg: String
    var data: [ImageLinked]
}
