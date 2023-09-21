//
//  Color+Extension.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

extension Color {
    static let shootBlack = Color("shootBlack")
    static let shootGray = Color("shootGray")
    static let shootLight = Color("shootLight")
    static let shootBlue = Color("shootBlue")
    static let shootYellow = Color("shootYellow")
    static let shootRed = Color("shootRed")
    static let shootWhite = Color("shootWhite")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
