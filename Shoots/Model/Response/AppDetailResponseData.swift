//
//  AppDetailResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/29.
//

import SwiftUI

struct AppDetailResponseData: Codable {
    var linkApplicationName: String?
    var linkApplicationOfficialName: String?
    var applicationTypeName: String?
    var description: String?
    var isOfficial: String?
    var appUrl: String?
    var appLogoUrl: String?
}
