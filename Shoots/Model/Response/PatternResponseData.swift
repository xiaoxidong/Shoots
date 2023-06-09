//
//  PatternData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct PatternResponseData: Codable {
    var code: Int
    var msg: String
    var data: [Pattern]
}

struct Pattern: Codable, Identifiable, Hashable {
    var id: String
    var designPatternName: String
    var count: String?
}
