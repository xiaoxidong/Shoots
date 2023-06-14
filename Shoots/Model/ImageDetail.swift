//
//  ImageDetailResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/29.
//

import SwiftUI

struct ImageDetail: Codable {
    var id: String?
    var picUrl: String
    var compressedPicUrl: String
    var linkApplicationId: String?
    var linkApplicationOfficialId: String?
    var fileName: String
    var fileSuffix: String
    var linkApplicationName: String?
    var description: String?
    var appUrl: String?
    var appLogoUrl: String?
    var isFavorite: Int
    var userName: String?
    var uploadNum: String
    var favoriteNum: String
    var designPatternList: [PatternName]
    
    struct PatternName: Codable, Identifiable, Hashable {
        var id: String
        var designPatternName: String
    }
}
