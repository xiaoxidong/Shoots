//
//  SelfViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class SelfViewModel: ObservableObject {
    
    @Published var favorites: [Favorite] = []
    @Published var apps: [UploadAblum] = []
    
    var favoritesPicNum: Int {
        var num = 0
        favorites.forEach { favorite in
            num += favorite.countPics
        }
        return num
    }
    func getFavorites() async {
        APIService.shared.GET(url: .allFavorite, params: nil) { (result: Result<FavoriteResponseData, APIService.APIError>) in
            switch result {
            case .success(let favorite):
                self.favorites = favorite.data
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
    
    var appPicNum: Int {
        var num: Int = 0
        apps.forEach { app in
            num += app.countPics
        }
        return num
    }
    func uploadPicGroup() async {
        APIService.shared.GET(url: .uploadPicGroup, params: nil) { (result: Result<UploadResponseData, APIService.APIError>) in
            switch result {
            case .success(let app):
                self.apps = app.data
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
    
    @Published var patternFeed: [Picture] = []
    var page: Int = 1
    var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    func getPatternPics(id: String) async {
        self.noMore = false
        self.footerRefreshing = false
        self.page = 1
        
        APIService.shared.POST(url: .patternPics, params: ["pageSize" : numberPerpage, "pageNum": 1, "designPatternId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let pattern):
                self.patternFeed = pattern.rows
                self.mostPages = pattern.total / numberPerpage + 1
                if pattern.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
    
    func nextPage(id: String) async {
        self.page += 1
        APIService.shared.POST(url: .patternPics, params: ["pageSize" : numberPerpage, "pageNum": page, "designPatternId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let pattern):
                DispatchQueue.main.async {
                    self.patternFeed.append(contentsOf: pattern.rows)
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
    
    @Published var userPattern: [Pattern] = []
    func getUserPattern() async {
        APIService.shared.GET(url: .userPattern, params: nil) { (result: Result<UserPatternResponseData, APIService.APIError>) in
            switch result {
            case .success(let userPattern):
                self.userPattern = userPattern.data
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
}
