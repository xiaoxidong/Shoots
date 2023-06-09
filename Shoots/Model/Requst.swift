//
//  Requst.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/14.
//

import SwiftUI

enum URLPath {
    case login
    case feed
    case pattern
    case apps
    case allFavorite
    case addFavorite
    case addPicToFavorite
    case removePicFromFavorite
    case favoritePics
    case editFavoriteName
    case upload
    case uploadImage
    case imageDetail
    case appDetail
    case appPics
    case userPattern
    case uploadPicGroup
    case patternPics
    case report
    
    var path: String {
        switch self {
        case .login:
            return "/app/login"
        case .pattern:
            return "/app/pattern/list"
        case .apps:
            return "/app/application/list"
        case .allFavorite:
            return "/app/favorite/list"
        case .addFavorite:
            return "/app/favorite/add"
        case .addPicToFavorite:
            return "/app/pic/bookmark"
        case .removePicFromFavorite:
            return "/app/pic/unBookmark"
        case .favoritePics:
            return "/app/favorite/pics"
        case .editFavoriteName:
            return "/app/favorite/update"
        case .feed:
            return "/app/pic/feed"
        case .upload:
            return "/app/pic/upload"
        case .uploadImage:
            return "/system/oss/upload"
        case .imageDetail:
            return "/app/pic/detail/"
        case .appDetail:
            return "/app/application/detail/"
        case .appPics:
            return "/app/application/pics"
        case .userPattern:
            return "/app/pattern/pattern"
        case .uploadPicGroup:
            return "/app/application/group"
        case .patternPics:
            return "/app/pic/pattern"
        case .report:
            return "/app/pic/report"
        }
    }
}
