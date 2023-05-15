//
//  HomeViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import Alamofire

class HomeViewModel: ObservableObject {
    // 首页的图片数据
    @Published var shoots: [Shoot] = []
    @Published var showAlert = false
    // 首页的页数
    var page: Int = 0
    
    init() {
        getData()
    }
    
    func getData() {
        // 当前页面的下一页
        self.page += 1
        
        // 请求下一页的数据
        // 没有后端的时候模拟数据
        shoots = homeData
    }
}
