//
//  ImageDetailResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/29.
//

import SwiftUI

struct ImageDetail: Codable {
    var id: String
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
    var chooseType: String?
    var picDescription: String?
    
    // 1 交互细节、2 用户体验、3 设计更新、4 截图
    var lists: [PatternName] {
        var new = designPatternList
        
        if chooseType == ImageType.gif.rawValue {
            new.insert(PatternName(id: "", designPatternName: ImageType.gif.name, type: .gif), at: 0)
        } else if chooseType == ImageType.interaction.rawValue {
            new.insert(PatternName(id: "", designPatternName: ImageType.interaction.name, type: .interaction), at: 0)
        } else if chooseType == ImageType.new.rawValue {
            new.insert(PatternName(id: "", designPatternName: ImageType.new.name, type: .new), at: 0)
        }
        
        return new
    }

    struct PatternName: Codable, Identifiable, Hashable {
        var id: String
        var designPatternName: String
        var type: ImageType?
    }
}
