//
//  DetailViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var detail: ImageDetail? = nil
    @Published var favorites: [Favorite] = []
    
    func getImageDetail(id: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.GET(url: .imageDetail(id: id), params: nil) { (result: Result<ImageDetail, APIService.APIError>) in
            switch result {
            case .success(let detail):
                self.detail = detail
                success(true)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    func addFavorites(name: String) async {
        APIService.shared.POST(url: .addFavorite, params: ["favoriteFileName" : name]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(_):
                self.favorites.removeAll()
                Task {
                    await self.getFavorites()
                }
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
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
    
    func savePics(pics: [String], favoriteFileId: String) async {
        APIService.shared.POST(url: .addPicToFavorite, params: ["picIds" : pics, "favoriteFileId": favoriteFileId]) { (result: Result<Response, APIService.APIError>) in
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