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
    
    @Published var update = false
    init() {
        if let localApps = Defaults().get(for: .localApps) {
            apps = localApps
            suggestionApps = localApps.filter({ $0.isOfficial == "1" }).choose(20)
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
                self.apps = apps.data
                Task {
                    for app in self.apps {
                        await self.logo(app: app) { url in
                            self.add(app: app, url: url)
                        }
                    }
                }
            case .failure(let error):
                print("获取所有应用错误: \(error)")
                break
            }
        }
    }
    
    func getAppLogo(_ success: @escaping (Bool) -> Void) {
        Task {
            for app in apps {
                await logo(app: app) { url in
                    self.add(app: app, url: url)
                }
            }
            success(true)
        }
    }
    
    func add(app: AppInfo, url: String?) {
        var new = app
        new.appLogoUrl = url
        self.newApps.append(new)
        
        if newApps.count == apps.count {
            set()
        }
    }
    
    func set() {
        DispatchQueue.main.async {
            self.apps = self.newApps
            self.suggestionApps = self.newApps.filter({ $0.isOfficial == "1" }).choose(20)
        }
        
        // && $0.appLogoUrl != nil
        Defaults().set(self.newApps, for: .localApps)
    }
    
    var newApps: [AppInfo] = []
    func logo(app: AppInfo, _ success: @escaping (String?) -> Void) async {
        if let id = app.appStoreId {
            if !self.apps.contains(app) {
                
            }
            AF.request("https://itunes.apple.com/us/lookup?id=\(id)", method: .get, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppDetailInfo.self) { response in
                switch response.result {
                case .success(let object):
                    success(object.results.first?.artworkUrl512)
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            success(nil)
        }
    }
}

class Upload {
    var urls: [String] = []
    func uploadImages(images: [String], _ success: @escaping ([String]) -> Void) {
        Task {
            for image in images {
                async let url = await upload(image: image)
                await urls.append(url)
            }
            success(urls)
        }
    }
    func upload(image: String) async -> String {
        // 上传，成功之后获得一个 string
        let string = "ddddd"
        print("---------")
        return string
    }
}
