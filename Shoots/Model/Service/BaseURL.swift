//
//  BaseURL.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/15.
//

import SwiftUI

#if DEBUG
    // #error("输入服务器地址")
    let baseURL: String = "https://poke.design/shoots-api"
// http://124.222.232.27:8080
#else
    let baseURL: String = "https://poke.design/shoots-api"
#endif
