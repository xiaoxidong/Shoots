//
//  Collection+Extension.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/7/20.
//

import SwiftUI

extension Array where Element == AppInfo {
    func choose(_ n: Int) -> [Element] {
        return Array(shuffled().prefix(n))
    }
}
