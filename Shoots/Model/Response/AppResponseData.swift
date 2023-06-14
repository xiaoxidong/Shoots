//
//  AppData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct AppResponseData: Codable {
    var code: Int
    var msg: String
    var data: [AppInfo]
}
