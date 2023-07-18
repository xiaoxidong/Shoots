//
//  InfoViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI
import Alamofire

class InfoViewModel: ObservableObject {
    @Published var patterns: [Pattern] = Defaults().get(for: .localPatterns) ?? []
    @Published var apps: [AppInfo] =  []
    @Published var suggestionApps: [AppInfo] = []
    
    init() {
        if let localApps = Defaults().get(for: .localApps) {
            apps = localApps
            suggestionApps = localApps.filter({ $0.isOfficial == "1" })
        }
        Task {
            await self.getAllPatterns()
            await self.getApps()
        }
    }
    // 获取所有的设计模式
    func getAllPatterns() async {
        APIService.shared.GET(url: .pattern, params: nil) { (result: Result<PatternResponseData, APIService.APIError>) in
            switch result {
            case .success(let pattern):
                self.patterns = pattern.data
                Defaults().set(pattern.data, for: .localPatterns)
            case .failure(let error):
                print("获取所有设计模式错误: \(error)")
                break
            }
        }
    }
    
    // 获取所有的应用
    func getApps() async {
        APIService.shared.GET(url: .apps, params: nil) { (result: Result<AppResponseData, APIService.APIError>) in
            switch result {
            case .success(let apps):
                Task {
                    await self.getAppLogo(apps: apps.data)
                }
            case .failure(let error):
                print("获取所有应用错误: \(error)")
                break
            }
        }
    }
    
    func getAppLogo(apps: [AppInfo]) async {
        var newApps: [AppInfo] = []
        for app in apps {
            if let id = app.appStoreId {
                if !self.apps.contains(app) {
                    
                }
                AF.request("https://itunes.apple.com/us/lookup?id=\(id)", method: .get, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppDetailInfo.self) { response in
                    switch response.result {
                    case .success(let object):
                        print(object)
                        var new = app
                        new.appLogoUrl = object.results.first?.artworkUrl512
                        newApps.append(new)
                        
                        if newApps.count == apps.count {
                            self.apps = newApps
                            self.suggestionApps = newApps.filter({ $0.isOfficial == "1" })
                            // && $0.appLogoUrl != nil
                            Defaults().set(newApps, for: .localApps)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
