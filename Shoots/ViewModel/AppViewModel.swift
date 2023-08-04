//
//  AppViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import Alamofire
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var loading = false

    @Published var app: AppDetail? = nil
    @Published var appFeed: [Picture] = []

    @Published var flows: [Flow] = []

    @Published var info: Info? = nil

    // 应用基本信息
    func info(id: String) async {
        let code = Locale.current.language.region?.identifier ?? "us"
        AF.request("https://itunes.apple.com/\(code)/lookup?id=\(id)", method: .get, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppDetailInfo.self) { response in
            switch response.result {
            case let .success(object):
                print(object)
                if object.results.isEmpty {
                    Task {
                        await self.usInfo(id: id)
                    }
                } else {
                    self.info = object.results.first
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    func usInfo(id: String) async {
        AF.request("https://itunes.apple.com/us/lookup?id=\(id)", method: .get, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppDetailInfo.self) { response in
            switch response.result {
            case let .success(object):
                print(object)
                self.info = object.results.first
            case let .failure(error):
                print(error)
            }
        }
    }

    // 获取应用详情，暂时没用了
    func getAppDetail(id: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.GET(url: .appDetail(id: id), params: nil) { (result: Result<AppDetail, APIService.APIError>) in
            switch result {
            case let .success(app):
                self.app = app
                success(true)
            case let .failure(error):
                print("获取图片详情错误: \(error)")
            }
        }
    }

    // 获取图片组
    func appFlows(id _: String) async {}

    var page: Int = 1
    var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    // 图片详情页获取所有的图片
    func appPics(id: String) async {
        DispatchQueue.main.async {
            self.loading = true
            self.noMore = false
            self.footerRefreshing = false
        }

        page = 1

        AF.request("\(baseURL)\(APIService.URLPath.appPics.path)", method: .post, parameters: ["pageSize": numberPerpage, "pageNum": page, "linkApplicationId": id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppImageResponseData.self) { response in
            switch response.result {
            case let .success(app):
                self.appFeed = app.rows
                self.mostPages = app.total / numberPerpage + 1
                if app.rows.count < numberPerpage {
                    self.noMore = true
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print(error)
            }
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }

    // 图片详情页获取所有的图片，下一页数据
    func nextPage(id: String) async {
        page += 1
        AF.request("\(baseURL)\(APIService.URLPath.appPics.path)", method: .post, parameters: ["pageSize": numberPerpage, "pageNum": page, "linkApplicationId": id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppImageResponseData.self) { response in
            switch response.result {
            case let .success(app):
                DispatchQueue.main.async {
                    self.appFeed.append(contentsOf: app.rows)
                    self.footerRefreshing = false
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
