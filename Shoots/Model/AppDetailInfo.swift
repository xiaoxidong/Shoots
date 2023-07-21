//
//  AppDetailInfo.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/7/7.
//

import SwiftUI

struct AppDetailInfo: Codable {
    var resultCount: Int
    var results: [Info]
}

struct Info: Codable {
    var artworkUrl512: String
    var trackName: String
    var genres: [String]
    var description: String
    var trackViewUrl: String

    var descriptionWithoutSpace: String {
        description.replacingOccurrences(of: "\n\n", with: "\n")
    }
}
