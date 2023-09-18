//
//  ImageDetailResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/18.
//

import SwiftUI

struct ImageDetailResponseData: Codable {
    var code: Int
    var msg: String
    var data: ImageDetail
}
