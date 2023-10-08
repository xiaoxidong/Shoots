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
//    var linkedOrBeLinked: LinkedOrBeLinked? = nil

    var compressedPicUrl: String {
        picUrl + "?x-oss-process=image/format,heic"
        // "?x-oss-process=image/resize,l_923,h_600/format,heic"
        //?x-oss-process=image/resize,w_200/format,webp
    }
    
    var gifPicUrl: String {
        picUrl + "?x-oss-process=image/resize,m_lfit,w_440"
        // "?x-oss-process=image/resize,l_923,h_600/format,heic"
        //?x-oss-process=image/resize,w_200/format,webp
    }
    
    // 1 交互细节、2 用户体验、3 设计更新、4 截图
    var type: ImageType {
        if chooseType == ImageType.gif.rawValue {
            return .gif
        } else if chooseType == ImageType.interaction.rawValue {
            return .interaction
        } else if chooseType == ImageType.new.rawValue {
            return .new
        } else {
            return .image
        }
    }
}

enum LinkedOrBeLinked: String, Codable {
    case linked
    case beLinked

}

enum ImageType: String, Codable {
    case gif = "1"
    case interaction = "2"
    case new = "3"
    case image = "4"
    
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
    
    var uploadImage: String {
        switch self {
        case .gif:
            return "number"
        case .interaction:
            return "person.and.background.dotted"
        case .new:
            return "flag.checkered"
        case .image:
            return "number"
        }
    }
    
    //1 交互细节、2 用户体验、3 设计更新、4 截图
    var name: String {
        switch self {
        case .gif:
            return "交互细节"
        case .interaction:
            return "用户体验"
        case .new:
            return "设计更新"
        case .image:
            return "截图"
        }
    }
    
    var color: Color {
        switch self {
        case .gif:
            return Color.pink.opacity(0.12)
        case .interaction:
            return Color.purple.opacity(0.12)
        case .new:
            return Color.blue.opacity(0.12)
        case .image:
            return Color.pink.opacity(0.12)
        }
    }
}
