//
//  UploadCodableData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/29.
//

import SwiftUI

struct UploadImageResponseData: Codable {
    var code: Int
    var msg: String
    var data: Upload

    struct Upload: Codable {
        var url: String
        var fileName: String
        var ossId: String
    }
}
