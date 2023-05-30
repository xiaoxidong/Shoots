//
//  FavoriteData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct Picture: Codable, Identifiable {
    var id: String
    var picUrl: String
    var compressedPicUrl: String
    var linkApplicationId: String?
    var linkApplicationOfficialId: String?
}
