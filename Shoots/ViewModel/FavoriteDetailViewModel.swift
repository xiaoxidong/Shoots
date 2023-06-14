//
//  FavoriteDetailViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class FavoriteDetailViewModel: ObservableObject {
    @Published var favoriteFeed: [Picture] = []
    
    func favoritePics(id: String) async {
        APIService.shared.POST(url: .favoritePics, params: ["pageSize" : 20, "pageNum": 1, "orderByColumn": "", "isAsc": "true", "favoriteFileId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
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
        APIService.shared.POST(url: .addFavorite, params: ["picIds" : pics]) { (result: Result<Response, APIService.APIError>) in
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
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    func removeFavorite(id: [String], _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .removePicFromFavorite, params: ["picIds" : id]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                print(feeds)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
}
