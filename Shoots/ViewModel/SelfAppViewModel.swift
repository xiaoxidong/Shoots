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
    
    func appFlows(id: String) async {
        
    }
    
    var page: Int = 1
    var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    func appPics(id: String) async {
        self.noMore = false
        self.footerRefreshing = false
        self.page = 1
        APIService.shared.POST(url: .appPics, params: ["pageSize" : numberPerpage, "pageNum" : page, "linkApplicationId" : id]) { (result: Result<AppImageResponseData, APIService.APIError>) in
            switch result {
            case .success(let app):
                self.appFeed = app.rows
                self.mostPages = app.total / numberPerpage + 1
                if app.rows.count < numberPerpage {
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
        APIService.shared.POST(url: .appPics, params: ["pageSize" : page, "pageNum" : page, "linkApplicationId" : id]) { (result: Result<AppImageResponseData, APIService.APIError>) in
            switch result {
            case .success(let app):
                DispatchQueue.main.async {
                    self.appFeed.append(contentsOf: app.rows)
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
    
    func deletePics(ids: [String], _ success: @escaping (Bool) -> Void) async {
        APIService.shared.POST(url: .deleteImage, params: ["picIds" : ids]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(let app):
                print(app)
                success(true)
                ids.forEach { id in
                    if let index = self.appFeed.firstIndex(where: { $0.id == id }) {
                        self.appFeed.remove(at: index)
                    }
                }
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
}
