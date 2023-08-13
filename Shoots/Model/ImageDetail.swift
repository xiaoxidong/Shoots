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
    var linkApplicationId: String?
    var linkApplicationOfficialId: String?
    var fileName: String
    var fileSuffix: String
    var linkApplicationName: String?
    var appStoreId: String?
    var description: String?
    var appUrl: String?
    var appLogoUrl: String?
    var isFavorite: Int?
    var userName: String?
    var avatar: String?
    var uploadNum: String
    var favoriteNum: String
    var designPatternList: [PatternName]
    
    var lists: [PatternName] {
        var new = designPatternList
        new.insert(PatternName(id: "", designPatternName: "最近更新", type: "type"), at: 0)
        return new
    }

    struct PatternName: Codable, Identifiable, Hashable {
        var id: String
        var designPatternName: String
        var type: String?
    }
}
