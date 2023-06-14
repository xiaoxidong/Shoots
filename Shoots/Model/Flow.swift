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

var flow: Flow = Flow(images: ["s9", "s10", "s3", "s4", "s5"], name: "注册用户", description: "DISCOVER MILLIONS OF POSSIBILITIES.Choose from unique homes—near or far—in many countries around the world. Find everything from getaways near national parks to apartments in the hea...")
