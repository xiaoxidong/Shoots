//
//  File.swift
//
//
//  Created by 변경민 on 2020/12/23.
//

import Foundation

public enum TagFieldStyle {
    case RoundedBorder
    case Modern
    case Multilined
}

extension String {
    func isContainSpaceAndNewlines() -> Bool {
        return rangeOfCharacter(from: .newlines) != nil
    }
}
