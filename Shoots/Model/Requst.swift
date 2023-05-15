//
//  Requst.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/14.
//

import SwiftUI

#if DEBUG
let baseURL: String = "http://124.222.232.27:8080"
#else
let baseURL: String = ""
#endif

enum URLPath {
    case login
    case feed
    
    var path: String {
        switch self {
        case .login:
            return "/app/login"
        case .feed:
            return baseURL
        }
    }
}
