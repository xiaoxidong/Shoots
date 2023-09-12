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
    var chooseType: String?

    var compressedPicUrl: String {
        picUrl + "?x-oss-process=image/format,heic"
        // "?x-oss-process=image/resize,l_923,h_600/format,heic"
    }
    
    // 1 交互细节、2 用户体验、3 设计更新、4 截图
    var type: ImageType {
        if chooseType == "1" {
            return .gif
        } else if chooseType == "2" {
            return .interaction
        } else if chooseType == "3" {
            return .new
        } else {
            return .image
        }
    }
}

enum ImageType: String, Codable {
    case gif
    case interaction
    case new
    case image
    
    var image: String {
        switch self {
        case .gif:
            return "gif"
        case .interaction:
            return "detail"
        case .new:
            return "new"
        case .image:
            return "gif"
        }
    }
}
