//
//  FavoriteResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/29.
//

import SwiftUI

struct FavoriteResponseData: Codable {
    var code: Int
    var msg: String
    var data: [FavoriteData]
}

struct FavoriteData: Codable, Identifiable {
    var id: String
    var favoriteFileName: String
    var previewPics: [Pic]
    
    struct Pic: Codable {
        var id: Int
        var picUrl: String
        var compressedPicUrl: String
        var linkApplicationId: Int
        var linkApplicationOfficialId: Int
    }
    
    var pics: [String] {
        var urls: [String] = []
        
        if previewPics.count <= 3 {
            for pic in previewPics {
                urls.append(pic.compressedPicUrl)
            }
        } else {
            for pic in previewPics.prefix(3) {
                urls.append(pic.compressedPicUrl)
            }
        }
        return urls
    }
}
