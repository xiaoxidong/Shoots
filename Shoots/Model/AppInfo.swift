//
//  AppInfo.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

struct AppInfo: Codable, Identifiable, Hashable {
    var id: String
    var linkApplicationName: String
    var description: String?
    var appUrl: String?
    var isOfficial: String
    var appLogoUrl: String?
}
