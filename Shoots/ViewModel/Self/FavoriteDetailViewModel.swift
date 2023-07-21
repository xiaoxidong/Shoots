//
//  FavoriteDetailViewModel.swift
//  Shoots
//  收藏的详情页，所有截图及操作
//  Created by XiaoDong Yuan on 2023/6/14.
//

import Alamofire
import SwiftUI

class FavoriteDetailViewModel: ObservableObject {
    @Published var favoriteFeed: [Picture] = []

    @Published var footerRefreshing = false
    @Published var noMore = false
    var page: Int = 1
    var mostPages: Int = 1
    // 系列下的所有截图
    func favoritePics(id: String) async {
        noMore = false
        footerRefreshing = false
        page = 1

        APIService.shared.POST(url: .favoritePics, params: ["pageSize": numberPerpage, "pageNum": 1, "orderByColumn": "", "isAsc": "true", "favoriteFileId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case let .success(feeds):
                self.favoriteFeed = feeds.rows
                self.mostPages = feeds.total / numberPerpage + 1
                if feeds.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("获取系列详情错误: \(error)")
            }
        }
    }

    // 下一页数据
    func nextPage(id: String) async {
        page += 1
        APIService.shared.POST(url: .favoritePics, params: ["pageSize": numberPerpage, "pageNum": page, "favoriteFileId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case let .success(feeds):
                self.favoriteFeed.append(contentsOf: feeds.rows)
            case let .failure(error):
                print("获取系列详情下一页错误: \(error)")
            }
        }
    }

    // 编辑系列名称
    func editFavoriteName(id: String, name: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .editFavoriteName, params: ["favoriteFileId": id, "favoriteFileName": name]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case let .success(feeds):
                print(feeds)
                success(true)
            case let .failure(error):
                print("编辑系列名称错误: \(error)")
            }
        }
    }

    // 截图移除系列
    func removeFavorite(pics: [String], id: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .removePicFromFavorite, params: ["picIds": pics, "favoriteFileId": id]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case let .success(feeds):
                print(feeds)
                pics.forEach { pic in
                    if let index = self.favoriteFeed.firstIndex(where: { $0.id == pic }) {
                        self.favoriteFeed.remove(at: index)
                    }
                }
                success(true)
            case let .failure(error):
                print("移除系列错误: \(error)")
                success(false)
            }
        }
    }

    // 删除系列
    func deleteFavorite(id: String, _ success: @escaping (Bool) -> Void) async {
        AF.request("\(baseURL)\(APIService.URLPath.deleteFavorite.path)\(id)", method: .delete, parameters: ["favoriteFileId": id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization": "Bearer \(APIService.token)"]).responseDecodable(of: Response.self) { response in
            switch response.result {
            case let .success(object):
                print(object)
                success(true)
            case let .failure(error):
                print("删除系列错误: \(error)")
            }
        }
    }
}
