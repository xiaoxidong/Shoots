//
//  FavoriteData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct Picture: Codable, Identifiable {
    var id: String
    var picUrl: String
    var linkApplicationId: String?
    var linkApplicationOfficialId: String?
    
    var compressedPicUrl: String {
        picUrl + "?x-oss-process=image/format,heic"
        // "?x-oss-process=image/resize,l_923,h_600/format,heic"
    }
}
