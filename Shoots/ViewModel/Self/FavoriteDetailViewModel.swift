//
//  FavoriteDetailViewModel.swift
//  Shoots
//  收藏的详情页，所有截图及操作
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI
import Alamofire

class FavoriteDetailViewModel: ObservableObject {
    @Published var favoriteFeed: [Picture] = []
    
    @Published var footerRefreshing = false
    @Published var noMore = false
    var page: Int = 1
    var mostPages: Int = 1
    // 系列下的所有截图
    func favoritePics(id: String) async {
        self.noMore = false
        self.footerRefreshing = false
        self.page = 1
        
        APIService.shared.POST(url: .favoritePics, params: ["pageSize" : numberPerpage, "pageNum": 1, "orderByColumn": "", "isAsc": "true", "favoriteFileId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                self.favoriteFeed = feeds.rows
                self.mostPages = feeds.total / numberPerpage + 1
                if feeds.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print("获取系列详情错误: \(error)")
                break
            }
        }
    }
    // 下一页数据
    func nextPage(id: String) async {
        self.page += 1
        APIService.shared.POST(url: .favoritePics, params: ["pageSize" : numberPerpage, "pageNum": page, "favoriteFileId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                self.favoriteFeed.append(contentsOf: feeds.rows)
            case .failure(let error):
                print("获取系列详情下一页错误: \(error)")
                break
            }
        }
    }
    
    // 编辑系列名称
    func editFavoriteName(id: String, name: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .editFavoriteName, params: ["favoriteFileId" : id, "favoriteFileName": name]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                print(feeds)
                success(true)
            case .failure(let error):
                print("编辑系列名称错误: \(error)")
                break
            }
        }
    }
    
    // 截图移除系列
    func removeFavorite(pics: [String], id: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .removePicFromFavorite, params: ["picIds" : pics, "favoriteFileId" : id]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                print(feeds)
                pics.forEach { pic in
                    if let index = self.favoriteFeed.firstIndex(where: { $0.id == pic }) {
                        self.favoriteFeed.remove(at: index)
                    }
                }
                success(true)
            case .failure(let error):
                print("移除系列错误: \(error)")
                success(false)
                break
            }
        }
    }
    // 删除系列
    func deleteFavorite(id: String, _ success: @escaping (Bool) -> Void) async {
        AF.request("\(baseURL)\(APIService.URLPath.deleteFavorite.path)\(id)", method: .delete, parameters: ["favoriteFileId" : id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(APIService.token)"]).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let object):
                print(object)
                success(true)
            case .failure(let error):
                print("删除系列错误: \(error)")
            }
        }
    }
}
