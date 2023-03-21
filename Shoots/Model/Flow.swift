//
//  Flow.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

struct Flow: Identifiable, Codable {
    var id = UUID()
    var images: [String] = []
    var name: String
    var description: String
}
