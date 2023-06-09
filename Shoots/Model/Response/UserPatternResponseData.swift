//
//  UserPatternResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/7.
//

import SwiftUI

struct UserPatternResponseData: Codable {
    var code: Int
    var msg: String
    var data: [Pattern]
}
