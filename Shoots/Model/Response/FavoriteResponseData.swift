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
    var data: [Favorite]
}
