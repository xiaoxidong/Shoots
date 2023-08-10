//
//  UploadAvatarResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/7.
//

import SwiftUI

struct UploadAvatarResponseData: Codable {
    var code: Int
    var msg: String
    var data: Upload

    struct Upload: Codable {
        var imgUrl: String
    }
}
