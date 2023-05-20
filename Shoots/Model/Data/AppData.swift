//
//  AppData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct AppData: Codable {
    var code: Int
    var msg: String
    var data: [Apps]
}

struct Apps: Codable, Identifiable {
    var id: String
    var linkApplicationName: String
    var description: String?
    var appUrl: String?
    var appLogoUrl: String?
}
