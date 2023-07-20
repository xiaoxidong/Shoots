//
//  DetailViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var loading = false
    @Published var detail: ImageDetail? = nil
    @Published var favorites: [Favorite] = []
    
    // 获取图片详情信息
    func getImageDetail(id: String, _ success: @escaping (Bool) -> Void) async {
        DispatchQueue.main.async {
            self.loading = true
        }
       
        APIService.shared.GET(url: .imageDetail(id: id), params: nil) { (result: Result<ImageDetail, APIService.APIError>) in
            switch result {
            case .success(let detail):
                self.detail = detail
                success(true)
            case .failure(let error):
                print("图片详情错误: \(error)")
                break
            }
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    // 新建系列
    func addFavorites(name: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .addFavorite, params: ["favoriteFileName" : name]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(_):
                Task {
                    await self.getFavorites()
                }
                success(true)
            case .failure(let error):
                print("新建系列错误: \(error)")
                break
            }
        }
    }
    
    // 获取所有的系列
    @Published var loadingFavorites = true
    func getFavorites() async {
        APIService.shared.GET(url: .allFavorite, params: nil) { (result: Result<FavoriteResponseData, APIService.APIError>) in
            switch result {
            case .success(let favorite):
                self.favorites = favorite.data
            case .failure(let error):
                print("获取所有系列错误: \(error)")
                break
            }
            
            DispatchQueue.main.async {
                self.loadingFavorites = false
            }
        }
    }
    
    // 添加图片到系列
    func savePics(pics: [String], favoriteFileId: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .addPicToFavorite, params: ["picIds" : pics, "favoriteFileId": favoriteFileId]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                print(feeds)
                success(true)
            case .failure(let error):
                print("添加图片到系列错误: \(error)")
                break
            }
        }
    }
}
