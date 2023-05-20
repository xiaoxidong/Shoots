//
//  FeedData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct FeedData: Codable {
    var msg: String
    var code: Int
    var total: Int
    var rows: [Picture]
}
