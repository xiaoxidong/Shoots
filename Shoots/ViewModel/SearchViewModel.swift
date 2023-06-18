//
//  SearchViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/15.
//

import SwiftUI
import Alamofire

class SearchViewModel: ObservableObject {
    @Published var searchResults: [Picture] = []
    @Published var appID: String? = nil {
        didSet {
            if appID != nil {
                showResult = true
                patternID = nil
            }
        }
    }
    @Published var patternID: String? = nil {
        didSet {
            if patternID != nil {
                showResult = true
                appID = nil
            }
        }
    }
    
    @Published var showResult = false {
        didSet {
            if !showResult {
                appID = nil
                patternID = nil
            }
        }
    }
    
    func search(text: String) {
        showResult = true
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
        
        AF.request("\(baseURL)\(APIService.URLPath.patternPics.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum": 1, "designPatternId": id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case .success(let pattern):
                self.patternFeed = pattern.rows
                self.objectWillChange.send()
                self.mostPages = pattern.total / numberPerpage + 1
                if pattern.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
        
//        APIService.shared.POST(url: .patternPics, params: ["pageSize" : numberPerpage, "pageNum": 1, "designPatternId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
//            switch result {
//            case .success(let pattern):
//                self.patternFeed = pattern.rows
//                self.objectWillChange.send()
//                self.mostPages = pattern.total / numberPerpage + 1
//                if pattern.rows.count < numberPerpage {
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
        APIService.shared.POST(url: .patternPics, params: ["pageSize" : numberPerpage, "pageNum": page, "designPatternId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let pattern):
                DispatchQueue.main.async {
                    self.patternFeed.append(contentsOf: pattern.rows)
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
}
