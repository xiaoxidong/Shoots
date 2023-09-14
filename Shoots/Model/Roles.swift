//
//  Role.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/13.
//

import SwiftUI

enum Roles: Codable {
    case examine // 审核
    case upload // 上传内容权限
    
    #if DEBUG
    var id: String {
        switch self {
        case .examine:
            return "1699813565683048450"
        case .upload:
            return ""
        }
    }
    #else
    var id: String {
        switch self {
        case .examine:
            return ""
        case .upload:
            return ""
        }
    }
    #endif
}
