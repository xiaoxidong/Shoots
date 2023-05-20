//
//  UserViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/14.
//

import SwiftUI
import Alamofire

class UserViewModel: ObservableObject {
    @Published var login = Defaults().get(for: .login) == nil ? false : true
    @Published var token: String? = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJsb2dpblR5cGUiOiJsb2dpbiIsImxvZ2luSWQiOiJhcHBfdXNlcjoxNjU5NTUwNzY1NTY4Mjk0OTEzIiwicm5TdHIiOiIxeEZ3cGVVOFNJa1BxdzZudXo3TVhudzBZWHBkYWpTdiIsInVzZXJJZCI6MTY1OTU1MDc2NTU2ODI5NDkxM30.1UkVIaxHH74jR-PfwTGFQBUrgCW8QIUbqh5BFdUq9YA" //Defaults().get(for: .login)
    
    @Published var patterns: [Pattern] = Defaults().get(for: .localPatterns) ?? []
    @Published var apps: [Apps] = Defaults().get(for: .localApps) ?? []
    
    @Published var allFavorite: [Favorite] = []
    
    // 首页数据
    @Published var homeFeed: [Picture] = []
    
    init() {
        Task {
            getAllPatterns()
            getApps()
        }
    }
    
    func login(appleUserId: String, identityToken: String, email: String?, fullName: String?, _ suceess: @escaping (Bool) -> Void) {
        AF.request("\(baseURL)\(URLPath.login.path)", method: .post, parameters: ["appleUserId" : appleUserId, "identityToken" : identityToken, "email" : email ?? "", "fullName" : fullName ?? ""], encoding: JSONEncoding.default).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success(let user):
                self.login = true
                Defaults().set(user.data.token, for: .login)
                suceess(true)
            case .failure(let error):
                print(error)
                suceess(false)
            }
        }
    }
    
    func getAllPatterns() {
        AF.request("\(baseURL)\(URLPath.pattern.path)", method: .get, headers: ["Authorization" : "Bearer \(token!)"]).responseDecodable(of: PatternData.self) { response in
            switch response.result {
            case .success(let pattern):
                print(pattern)
                self.patterns = pattern.data
                Defaults().set(pattern.data, for: .localPatterns)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getApps() {
        AF.request("\(baseURL)\(URLPath.apps.path)", method: .get, headers: ["Authorization" : "Bearer \(token!)"]).responseDecodable(of: AppData.self) { response in
            switch response.result {
            case .success(let apps):
                print(apps)
                self.apps = apps.data
                Defaults().set(apps.data, for: .localApps)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFeed() {
        AF.request("\(baseURL)\(URLPath.feed.path)", method: .post, parameters: ["pageSize" : 10, "pageNum" : 1], encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(token!)"]).responseDecodable(of: FeedData.self) { response in
            switch response.result {
            case .success(let feeds):
                print(feeds)
                self.homeFeed = feeds.rows
            case .failure(let error):
                print(error)
            }
        }
    }
}
