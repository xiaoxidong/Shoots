//
//  DeleteViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/7/29.
//

import Alamofire
import SwiftUI

class DeleteViewModel: ObservableObject {
    func delete(token: String, _ success: @escaping (Bool) -> Void) async {
        AF.request("\(baseURL)\(APIService.URLPath.deactivate.path)", method: .post, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]).responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success:
                success(true)
            case let .failure(error):
                print(error)
            }
        }
    }
}
