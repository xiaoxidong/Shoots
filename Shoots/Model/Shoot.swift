//
//  Shoots.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI


struct Shoot: Identifiable, Codable {
    var id = UUID()
    var imageUrl: String
    var originalImageUrl: String
    var app: Application
    var designType: [String] = []
    var author: Author
}
