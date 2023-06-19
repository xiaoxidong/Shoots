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
    var page: Int = 1
    var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    
    func getHomeFirstPageFeed() {
        self.noMore = false
        self.footerRefreshing = false
        self.page = 1
        APIService.shared.POST(url: .feed, params: ["pageSize" : numberPerpage, "pageNum" : 1]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                self.homeFeed = feeds.rows
                self.mostPages = feeds.total / numberPerpage + 1
                if feeds.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
    
    func nextPage() async {
        self.page += 1
        APIService.shared.POST(url: .feed, params: ["pageSize" : numberPerpage, "pageNum" : page]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let feeds):
                DispatchQueue.main.async {
                    self.homeFeed.append(contentsOf: feeds.rows)
                    self.footerRefreshing = false
                }
            case .failure(let error):
                print("Api Reqeust Error: \(error)")
                break
            }
        }
    }
}
