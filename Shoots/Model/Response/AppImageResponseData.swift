//
//  AppImageResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/30.
//

import SwiftUI

struct AppImageResponseData: Codable {
    var code: Int
    var total: Int
    var msg: String
    var rows: [Picture]
}
