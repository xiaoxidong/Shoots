//
//  FavoriteData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct FavoriteData: Codable {
    var code: Int
    var msg: String
    
    var data: [Favorite] = []
}

struct Favorite: Codable, Identifiable {
    var id: String
    var favoriteFileName: String
    var previewPics: [Picture]
}

struct Picture: Codable, Identifiable {
    var id: String
    var picUrl: String
    var compressedPicUrl: String
    var linkApplicationId: Int?
    var linkApplicationOfficialId: Int?
}
