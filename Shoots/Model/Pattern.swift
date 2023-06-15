//
//  Pattern.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

struct Pattern: Codable, Identifiable, Hashable {
    var id: String
    var designPatternName: String
    var isOfficial: String
    var count: String?
}
