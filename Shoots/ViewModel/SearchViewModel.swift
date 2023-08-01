//
//  SearchViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/15.
//

import Alamofire
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var update = false
    @Published var loading = false
    @Published var searchResults: [Picture] = []
    @Published var appID: String? = nil {
        didSet {
            if appID != nil {
                showResult = true
                patternID = nil
                patternName = nil
                update.toggle()
            }
        }
    }

    @Published var appStoreID: String? = nil

    @Published var patternID: String? = nil {
        didSet {
            if patternID != nil {
                showResult = true
                appID = nil
                patternName = nil
            }
        }
    }

    @Published var patternName: String? = nil {
        didSet {
            if patternName != nil {
                showResult = true
                appID = nil
                patternID = nil
            }
        }
    }

    @Published var showResult = false {
        didSet {
            if !showResult {
                appID = nil
                patternID = nil
                patternName = nil
            }
        }
    }

    func search(text: String) {
        patternName = text
        Task {
            await getPatternNamePics(name: text)
        }
        update.toggle()
    }

    @Published var patternFeed: [Picture] = []
    var page: Int = 1
    var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    // 根据设计模式 ID 获取设计模式下的图片
    func getPatternPics(id: String) async {
        DispatchQueue.main.async {
            self.noMore = false
            self.footerRefreshing = false
            self.loading = true
        }
        page = 1

        AF.request("\(baseURL)\(APIService.URLPath.patternPics.path)", method: .post, parameters: ["pageSize": numberPerpage, "pageNum": 1, "designPatternId": id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case let .success(pattern):
                self.patternFeed = pattern.rows
                self.objectWillChange.send()
                self.mostPages = pattern.total / numberPerpage + 1
                if pattern.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("根据 ID 获取设计模式图片错误: \(error)")
            }

            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }

    // 根据设计模式 ID 获取设计模式下的图片，下一页
    func nextPage(id: String) async {
        page += 1
        APIService.shared.POST(url: .patternPics, params: ["pageSize": numberPerpage, "pageNum": page, "designPatternId": id]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case let .success(pattern):
                DispatchQueue.main.async {
                    self.patternFeed.append(contentsOf: pattern.rows)
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("根据 ID 获取设计模式图片下一页错误: \(error)")
            }
        }
    }

    // 根据名称获取设计模式下的图片
    func getPatternNamePics(name: String) async {
        DispatchQueue.main.async {
            self.noMore = false
            self.footerRefreshing = false
            self.loading = true
        }
        page = 1

        AF.request("\(baseURL)\(APIService.URLPath.searchPattern.path)", method: .post, parameters: ["pageSize": numberPerpage, "pageNum": 1, "designPatternName": name], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case let .success(pattern):
                self.patternFeed = pattern.rows
                self.objectWillChange.send()
                self.mostPages = pattern.total / numberPerpage + 1
                if pattern.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("根据名称获取设计模式下的图片错误: \(error)")
            }

            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }

    // 根据名称获取设计模式下的图片，下一页
    func nextPatternNamePage(name: String) async {
        page += 1
        APIService.shared.POST(url: .patternPics, params: ["pageSize": numberPerpage, "pageNum": page, "designPatternName": name]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case let .success(pattern):
                DispatchQueue.main.async {
                    self.patternFeed.append(contentsOf: pattern.rows)
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print("根据名称获取设计模式下的图片下一页错误: \(error)")
            }
        }
    }
}
