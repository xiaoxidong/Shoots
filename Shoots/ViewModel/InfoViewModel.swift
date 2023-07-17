//
//  InfoViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class InfoViewModel: ObservableObject {
    @Published var patterns: [Pattern] = Defaults().get(for: .localPatterns) ?? []
    @Published var apps: [AppInfo] = Defaults().get(for: .localApps) ?? []
    
    init() {
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
                Defaults().set(apps.data, for: .localApps)
            case .failure(let error):
                print("获取所有应用错误: \(error)")
                break
            }
        }
    }
}
