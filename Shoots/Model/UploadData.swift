//
//  UploadData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct UploadData: Codable {
    var linkApplicationName: String = ""
    var designPatternName: String = ""
    var picUrl: String
    var fileName: String = ""
    var fileSuffix: String = ""
    
    var chooseType: String = "4"
    var picDescription: String = ""
    var linkedPicId: String = ""
}
