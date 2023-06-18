//
//  FavoriteDetailViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class FavoriteDetailViewModel: ObservableObject {
    @Published var favoriteFeed: [Picture] = []
    
    @Published var footerRefreshing = false
    @Published var noMore = false
    var page: Int = 1
    var mostPages: Int = 1
    
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
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    func nextPage(id: String) async {
        self.page += 1
        APIService.shared.POST(url: .favoritePics, params: ["pageSize" : numberPerpage, "pageNum": page, "favoriteFileId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                self.favoriteFeed.append(contentsOf: feeds.rows)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    func removePics(pics: [String]) async {
        APIService.shared.POST(url: .removePicFromFavorite, params: ["picIds" : pics]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                print(feeds)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    func editFavoriteName(id: String, name: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .editFavoriteName, params: ["favoriteFileId" : id, "favoriteFileName": name]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                print(feeds)
                success(true)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
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
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
}
