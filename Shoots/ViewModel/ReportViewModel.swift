//
//  ReportViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import SwiftUI

class ReportViewModel: ObservableObject {
    func report(picList: [Report]) async {
        APIService.shared.POST(url: .report, params: ["picList": picList]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case let .success(reponse):
                print(reponse)
            case let .failure(error):
                print("举报错误: \(error)")
            }
        }
    }
}
