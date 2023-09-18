//
//  ImageLinked.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/18.
//

import SwiftUI

struct ImageLinked: Codable, Identifiable {
    var id: String
    var linkTime: String
    var bindOrToBind: String

    
    var picUrl: String
    var linkApplicationId: String
    var linkApplicationOfficialId: String?
    var chooseType: String

    var compressedPicUrl: String {
        picUrl + "?x-oss-process=image/format,heic"
        // "?x-oss-process=image/resize,l_923,h_600/format,heic"
    }
}
