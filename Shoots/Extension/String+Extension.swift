//
//  String+Extension.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
