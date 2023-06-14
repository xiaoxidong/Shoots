//
//  AppViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var app: AppDetail? = nil
    @Published var appFeed: [Picture] = []
    
    func getAppDetail(id: String, _ success: @escaping (Bool) -> Void) async {
        APIService.shared.GET(url: .appDetail(id: id), params: nil) { (result: Result<AppDetail, APIService.APIError>) in
            switch result {
            case .success(let app):
                self.app = app
                success(true)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    func appFlows(id: String) async {
        
    }
    
    @State var appPageNumber: Int = 1
    @State var numberPerpage: Int = 20
    func appPics(id: String) async {
//        appPageNumber += 1
        APIService.shared.POST(url: .appPics, params: ["pageSize" : numberPerpage, "pageNum" : appPageNumber, "linkApplicationId" : id]) { (result: Result<AppImageResponseData, APIService.APIError>) in
            switch result {
            case .success(let app):
                self.appFeed.append(contentsOf: app.rows)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
}
