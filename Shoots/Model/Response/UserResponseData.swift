//
//  User.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct UserResponseData: Codable {
    var code: Int
    var msg: String
    var data: Token

    struct Token: Codable {
        var token: String
    }
}
