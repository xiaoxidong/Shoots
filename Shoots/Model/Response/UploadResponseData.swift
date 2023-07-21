//
//  UploadResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/12.
//

import SwiftUI

struct UploadResponseData: Codable {
    var code: Int
    var msg: String
    var data: [UploadAblum]
}
