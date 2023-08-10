//
//  SelfInfoResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/7.
//

import SwiftUI

struct SelfInfoResponseData: Codable {
    var code: Int
    var msg: String
    var data: SelfInfo
}
