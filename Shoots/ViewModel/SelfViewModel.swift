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
                print("api reqeust erro: \(error)")
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
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    @Published var patternFeed: [Picture] = []
    func getPatternPics(id: String) async {
        APIService.shared.POST(url: .patternPics, params: ["pageSize" : 20, "pageNum": 1, "orderByColumn": "", "isAsc": "true", "designPatternId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                self.patternFeed = feeds.rows
            case .failure(let error):
                print("api reqeust erro: \(error)")
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
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
}
