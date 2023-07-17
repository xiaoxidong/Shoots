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
    
    // 首页第一页数据
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
                print("首页信息流第一页错误: \(error)")
                break
            }
        }
    }
    
    // 首页下一页数据
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
                print("首页加载下一页错误: \(error)")
                break
            }
        }
    }
}
