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
    @Published var token: String? = Defaults().get(for: .login)
    
    func login(appleUserId: String, identityToken: String, email: String?, fullName: String?, _ suceess: @escaping (Bool) -> Void) {
        AF.request("\(baseURL)\(URLPath.login.path)", method: .post, parameters: ["appleUserId" : appleUserId, "identityToken" : identityToken, "email" : email ?? "", "fullName" : fullName ?? ""], encoding: JSONEncoding.default).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success(let user):
                self.login = true
                Defaults().set(user.data.token, for: .login)
                suceess(true)
            case .failure(_):
                suceess(false)
            }
        }
    }
}





//    .responseJSON { response in
//        print(response)
//        switch response.result {
//        case .success(let value):
//            if let json = value as? [String: Any] {
//                print(json["data"] as? [String: String])
//            }
//
//            do {
//                let locationObject = try JSONDecoder().decode(User.self, from: response.data!)
//
//                print(locationObject)
//
//            } catch  {
//                print(error)
//            }
//
//        case .failure(let error):
//            print(error)
//        }
//    }
struct User: Codable {
    var code: Int
    var msg: String
    var data: Token
    
    struct Token: Codable {
        var token: String
    }
}
