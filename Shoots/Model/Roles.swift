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
    
    var id: String {
        switch self {
        case .examine:
            return "1699813565683048450"
        case .upload:
            return "1703432003584278530"
        }
    }
}
