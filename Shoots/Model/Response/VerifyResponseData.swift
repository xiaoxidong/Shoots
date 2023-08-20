//
//  VerifyResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/20.
//

import SwiftUI

struct AuditResponseData: Codable {
    var code: Int
    var msg: String
    var total: Int
    var rows: [Audit]
}
