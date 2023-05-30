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
    case upload
    case uploadImage
    case imageDetail
    case appDetail
    case appPics
    
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
        }
    }
}
