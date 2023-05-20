//
//  PatternData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI

struct PatternData: Codable {
    var code: Int
    var msg: String
    var data: [Pattern]
}
struct Pattern: Codable, Identifiable {
    var id: String
    var designPatternName: String
}
