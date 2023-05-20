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
        case .feed:
            return "/app/pic/feed"
        }
    }
}
