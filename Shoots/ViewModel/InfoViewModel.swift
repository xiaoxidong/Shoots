//
//  InfoViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import Alamofire
import SwiftUI

class InfoViewModel: ObservableObject {
    @Published var images: [LocalImageData] = []
    
    @Published var patterns: [Pattern] = Defaults().get(for: .localPatterns) ?? []
    @Published var suggestionPatterns: [Pattern] = []
    @Published var apps: [AppInfo] = []
    @Published var suggestionApps: [AppInfo] = []

    @Published var update = false
    init() {
        if let localApps = Defaults().get(for: .localApps) {
            apps = localApps
            suggestionApps = localApps.filter { $0.isOfficial == "1" }.choose(20)
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
            case let .success(pattern):
                self.patterns = pattern.data.sorted(by: { $0.isOfficial < $1.isOfficial })
                self.suggestionPatterns = self.patterns.filter { $0.isOfficial == "1" }
                Defaults().set(pattern.data, for: .localPatterns)
            case let .failure(error):
                print("获取所有设计模式错误: \(error)")
            }
        }
    }

    // 获取所有的应用
    func getApps() async {
        APIService.shared.GET(url: .apps, params: nil) { (result: Result<AppResponseData, APIService.APIError>) in
            switch result {
            case let .success(apps):
                self.apps = apps.data.sorted(by: { $0.isOfficial < $1.isOfficial })
                Task {
                    for app in self.apps {
                        await self.logo(app: app) { url in
                            self.add(app: app, url: url)
                        }
                    }
                }
            case let .failure(error):
                print("获取所有应用错误: \(error)")
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
        newApps.append(new)

        if newApps.count == apps.count {
            set()
        }
    }

    func set() {
        DispatchQueue.main.async {
            self.apps = self.newApps
            self.suggestionApps = self.newApps.filter { $0.isOfficial == "1" }.choose(20)
        }

        // && $0.appLogoUrl != nil
        Defaults().set(newApps, for: .localApps)
    }

    var newApps: [AppInfo] = []
    func logo(app: AppInfo, _ success: @escaping (String?) -> Void) async {
        if let id = app.appStoreId {
            if !apps.contains(app) {}
            AF.request("https://itunes.apple.com/us/lookup?id=\(id)", method: .get, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseDecodable(of: AppDetailInfo.self) { response in
                switch response.result {
                case let .success(object):
                    success(object.results.first?.artworkUrl512)
                case let .failure(error):
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

    func upload(image _: String) async -> String {
        // 上传，成功之后获得一个 string
        let string = "ddddd"
        print("---------")
        return string
    }
}
