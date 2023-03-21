//
//  DesignType.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct Application: Identifiable, Codable {
    var id = UUID()
    var name: String
    var image: String
    var type: String
    var info: String
    var url: String
    var flows: [Flow] = []
}
