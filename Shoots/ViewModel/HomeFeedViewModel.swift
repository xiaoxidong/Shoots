//
//  HomeViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import Alamofire

class HomeFeedViewModel: ObservableObject {
    // 首页数据
    @Published var homeFeed: [Picture] = []
    @Published var page: Int = 1
    @State var numberPerpage: Int = 12
    @Published var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    
    func getHomeFirstPageFeed() {
        self.homeFeed.removeAll()
        self.noMore = false
        self.page = 1
        
        AF.request("\(baseURL)\(APIService.URLPath.feed.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : 1], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(APIService.token)"]).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case .success(let object):
                print(object)
            case .failure(let error):
                print(error)
            }
        }
        
//        APIService.shared.POST(url: .feed, params: ["pageSize" : numberPerpage, "pageNum" : 1]) { (result: Result<FeedResponseData, APIService.APIError>) in
//            switch result {
//            case .success(let feeds):
//                self.homeFeed.append(contentsOf: feeds.rows)
//                self.mostPages = feeds.total / self.numberPerpage + 1
//            case .failure(let error):
//                print("api reqeust erro: \(error)")
//                break
//            }
//        }
    }
    
    func nextPage() async {
        self.page += 1
        if self.page > self.mostPages {
            self.noMore = true
        } else {
            APIService.shared.POST(url: .feed, params: ["pageSize" : numberPerpage, "pageNum" : page]) { (result: Result<FeedResponseData, APIService.APIError>) in
                switch result {
                case .success(let feeds):
                    DispatchQueue.main.async {
                        self.homeFeed.append(contentsOf: feeds.rows)
                        withAnimation(.spring()) {
                            self.footerRefreshing = false
                        }
                    }
                case .failure(let error):
                    print("api reqeust erro: \(error)")
                    break
                }
            }
        }
    }
}
