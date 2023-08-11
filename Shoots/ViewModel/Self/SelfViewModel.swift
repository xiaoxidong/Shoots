//
//  SelfViewModel.swift
//  Shoots
//  个人中心
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class SelfViewModel: ObservableObject {
    @Published var loading = true
    @Published var favorites: [Favorite] = []
    @Published var apps: [UploadAblum] = []

    var favoritesPicNum: Int {
        var num = 0
        favorites.forEach { favorite in
            num += favorite.countPics
        }
        return num
    }

    // 获取所有系列
    func getFavorites() async {
        APIService.shared.GET(url: .allFavorite, params: nil) { (result: Result<FavoriteResponseData, APIService.APIError>) in
            switch result {
            case let .success(favorite):
                self.favorites = favorite.data
            case let .failure(error):
                print("获取所有系列错误: \(error)")
            }
        }
    }

    var appPicNum: Int {
        var num = 0
        apps.forEach { app in
            num += app.countPics
        }
        return num
    }

    // 个人上传和收藏的截图，按照应用的分类
    func uploadPicGroup() async {
        APIService.shared.GET(url: .uploadPicGroup, params: nil) { (result: Result<UploadResponseData, APIService.APIError>) in
            switch result {
            case let .success(app):
                self.apps = app.data
            case let .failure(error):
                print("获取所有上传的应用错误: \(error)")
            }
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }

    @Published var userPattern: [Pattern] = []
    // 用户上传和收藏的截图，按照设计模式的分类
    @Published var loadingPattern = false
    func getUserPattern() async {
        APIService.shared.GET(url: .userPattern, params: nil) { (result: Result<UserPatternResponseData, APIService.APIError>) in
            switch result {
            case let .success(userPattern):
                self.userPattern = userPattern.data
            case let .failure(error):
                print("个人中心获取所有的设计模式错误: \(error)")
            }
        }
    }

    @Published var patternFeed: [Picture] = []
    var page: Int = 1
    var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    // 根据设计模式 ID 获取个人在该设计模式下的截图
    func getPatternPics(id: String) async {
        DispatchQueue.main.async {
            self.noMore = false
            self.footerRefreshing = false
            self.page = 1
        }

        APIService.shared.POST(url: .selfPatternPic, params: ["pageSize": numberPerpage, "pageNum": 1, "designPatternId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case let .success(pattern):
                self.patternFeed = pattern.rows
                self.mostPages = pattern.total / numberPerpage + 1
                if pattern.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("个人中心获取分类下的图片错误: \(error)")
            }

            DispatchQueue.main.async {
                self.loadingPattern = false
            }
        }
    }

    // 下一页数据
    func nextPage(id: String) async {
        page += 1
        APIService.shared.POST(url: .selfPatternPic, params: ["pageSize": numberPerpage, "pageNum": page, "designPatternId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case let .success(pattern):
                DispatchQueue.main.async {
                    self.patternFeed.append(contentsOf: pattern.rows)
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("个人中心获取分类下的图片下一页错误: \(error)")
            }
        }
    }

    // 用户基本信息
    @Published var name: String = ""
    @Published var avatar: String? = nil
    func getInfo() async {
        APIService.shared.GET(url: .selfInfo) { (result: Result<SelfInfoResponseData, APIService.APIError>) in
            switch result {
            case let .success(user):
                print("获取成功")
                self.name = user.data.user.userName
                self.avatar = user.data.user.avatar
            case let .failure(error):
                print("获取个人信息报错: \(error)")
            }
        }
    }
}
