//
//  Verify.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/20.
//

import SwiftUI

struct Audit: Codable, Identifiable {
    var id: String
    var picUrl: String
    var fileName: String
    var fileSuffix: String
    var linkApplicationName: String
    var isOfficial: String
    var delFlag: String
    var isAudit: String
    var isReport: String
    var createTime: String
    
    var compressedPicUrl: String {
        picUrl + "?x-oss-process=image/format,heic"
        // "?x-oss-process=image/resize,l_923,h_600/format,heic"
    }
}
