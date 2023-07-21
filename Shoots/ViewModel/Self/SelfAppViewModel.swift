//
//  SelfAppViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/18.
//

import SwiftUI

class SelfAppViewModel: ObservableObject {
    @Published var appFeed: [Picture] = []
    @Published var flows: [Flow] = []

    var page: Int = 1
    var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    // 个人中心，按照应用上传图片的应用详情
    func appPics(id: String) async {
        noMore = false
        footerRefreshing = false
        page = 1
        APIService.shared.POST(url: .selfAppPic, params: ["pageSize": numberPerpage, "pageNum": page, "linkApplicationId": id]) { (result: Result<AppImageResponseData, APIService.APIError>) in
            switch result {
            case let .success(app):
                self.appFeed = app.rows
                self.mostPages = app.total / numberPerpage + 1
                if app.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("个人中心应用详情错误: \(error)")
            }
        }
    }

    // 下一页数据
    func nextPage(id: String) async {
        page += 1
        APIService.shared.POST(url: .selfAppPic, params: ["pageSize": page, "pageNum": page, "linkApplicationId": id]) { (result: Result<AppImageResponseData, APIService.APIError>) in
            switch result {
            case let .success(app):
                DispatchQueue.main.async {
                    self.appFeed.append(contentsOf: app.rows)
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("个人中心应用详情下一页错误: \(error)")
            }
        }
    }

    // 上传上传的图片
    func deletePics(ids: [String], _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .deleteImage, params: ["picIds": ids]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case let .success(app):
                print(app)
                success(true)
                ids.forEach { id in
                    if let index = self.appFeed.firstIndex(where: { $0.id == id }) {
                        self.appFeed.remove(at: index)
                    }
                }
            case let .failure(error):
                print("删除上传的图片错误: \(error)")
            }
        }
    }
}
