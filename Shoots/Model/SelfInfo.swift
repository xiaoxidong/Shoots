//
//  SelfInfo.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/7.
//

import SwiftUI

struct SelfInfo: Codable {
    var roleGroup: String
    var postGroup: String
    var user: InfoDetail
}

struct InfoDetail: Codable {
    var userId: String
    var openId: String
    var userName: String
    var userType: String
    var email: String
    var avatar: String?
    var status: String
    var roles: [Role]?
}

struct Role: Codable {
    var roleId: String
    var roleName: String?
    var roleKey: String?
    var roleSort: Int?
    var dataScope: String?
    var menuCheckStrictly: String?
    var deptCheckStrictly: String?
    var status: String?
    var remark: String?
    var createTime: String?
    var flag: Bool?
    var superAdmin: Bool?
}
