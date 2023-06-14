//
//  DefaultsKey+Extension.swift
//  Poke
//
//  Created by XiaoDong Yuan on 2020/12/1.
//

import SwiftUI


extension DefaultsKey {
    static let pro = Key<Bool>("pro")
    static let login = Key<String>("login")
    static let localPatterns = Key<[Pattern]>("localPatterns")
    static let localApps = Key<[AppInfo]>("localApps")
}

