//
//  AppViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI
import Alamofire

class AppViewModel: ObservableObject {
    @Published var app: AppDetail? = nil
    @Published var appFeed: [Picture] = []
    
    @Published var flows: [Flow] = []
    
    func getAppDetail(id: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.GET(url: .appDetail(id: id), params: nil) { (result: Result<AppDetail, APIService.APIError>) in
            switch result {
            case .success(let app):
                self.app = app
                success(true)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
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
        
        AF.request("\(baseURL)\(APIService.URLPath.appPics.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : page, "linkApplicationId" : id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppImageResponseData.self) { response in
            switch response.result {
            case .success(let app):
                self.appFeed = app.rows
                self.mostPages = app.total / numberPerpage + 1
                if app.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print(error)
            }
        }
//        APIService.shared.POST(url: .appPics, params: ["pageSize" : numberPerpage, "pageNum" : page, "linkApplicationId" : id]) { (result: Result<AppImageResponseData, APIService.APIError>) in
//            switch result {
//            case .success(let app):
//                self.appFeed = app.rows
//                self.mostPages = app.total / numberPerpage + 1
//                if app.rows.count < numberPerpage {
//                    self.noMore = true
//                    self.footerRefreshing = false
//                }
//            case .failure(let error):
//                print("api reqeust erro: \(error)")
//                break
//            }
//        }
    }
    
    func nextPage(id: String) async {
        self.page += 1
        AF.request("\(baseURL)\(APIService.URLPath.appPics.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : page, "linkApplicationId" : id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppImageResponseData.self) { response in
            switch response.result {
            case .success(let app):
                DispatchQueue.main.async {
                    self.appFeed.append(contentsOf: app.rows)
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print(error)
            }
        }
//        APIService.shared.POST(url: .appPics, params: ["pageSize" : page, "pageNum" : page, "linkApplicationId" : id]) { (result: Result<AppImageResponseData, APIService.APIError>) in
//            switch result {
//            case .success(let app):
//                DispatchQueue.main.async {
//                    self.appFeed.append(contentsOf: app.rows)
//                    self.footerRefreshing = false
//                }
//            case .failure(let error):
//                print("api reqeust erro: \(error)")
//                break
//            }
//        }
    }
}
