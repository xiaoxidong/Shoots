//
//  UploadAblum.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

struct UploadAblum: Codable, Identifiable {
    var id: String
    var linkApplicationName: String
    var countPics: Int
    var previewPics: [Pic]
    
    struct Pic: Codable {
        var id: String
        var picUrl: String
        var compressedPicUrl: String
        var linkApplicationId: String
        var linkApplicationOfficialId: String?
    }
    
    var pics: [String] {
        var urls: [String] = []
        
        if previewPics.count <= 3 {
            for pic in previewPics {
                urls.insert(pic.compressedPicUrl, at: 0)
            }
        } else {
            for pic in previewPics.prefix(3) {
                urls.insert(pic.compressedPicUrl, at: 0)
            }
        }
        return urls
    }
}
