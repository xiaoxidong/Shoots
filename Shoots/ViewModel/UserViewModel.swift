//
//  UserViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/14.
//

import SwiftUI
import Alamofire

var numberPerpage: Int = 20

class UserViewModel: ObservableObject {
    @Published var login: Bool = false
    @Published var token: String = Defaults().get(for: .login) ?? ""
    
    @Published var uploading = false
    @Published var error = false
    @Published var uploadIndex = 1
    init() {
        if Defaults().get(for: .login) == nil {
            Defaults().set("", for: .login)
        }
        login = Defaults().get(for: .login) == "" ? false : true
    }
    // TODO: 第一次进入的时候当没网的时候，处理
    // 登录
    func login(appleUserId: String, identityToken: String, email: String, fullName: String, _ success: @escaping (Bool) -> Void) {
        print(email)
        print(fullName)
        print(appleUserId)
        print(identityToken)
        APIService.shared.POST(url: .login, params: ["appleUserId" : appleUserId, "identityToken" : identityToken, "email" : email, "fullName" : fullName]) { (result: Result<UserResponseData, APIService.APIError>) in
            switch result {
            case .success(let user):
                print("Token: \(user.data.token)")
                self.login = true
                self.token = user.data.token
                APIService.token = user.data.token
                Defaults().set(user.data.token, for: .login)
                success(true)
            case .failure(let error):
                print("登录报错: \(error)")
                break
            }
        }
    }
    
    // MARK: 上传图片
    func uploadImages(localDatas: [LocalImageData], _ pics: @escaping ([UploadData]) -> Void) {
        var uploads: [UploadData] = []
        if !uploading {
            uploading = true
        }
        self.uploadIndex = 1
        localDatas.forEach { local in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(local.image, withName: "file", fileName: "file.png", mimeType: "image/png")
            }, to: "\(baseURL)\(APIService.URLPath.uploadImage.path)", method: .post, headers: ["Content-Type": "multipart/form-data", "Authorization" : "Bearer \(token)"])
                .responseDecodable(of: UploadImageResponseData.self) { response in
                switch response.result {
                case .success(let imageURL):
                    print(imageURL)
                    var data = UploadData(picUrl: imageURL.data.url)
                    data.linkApplicationName = local.app
                    data.designPatternName = local.pattern
                    data.fileName = imageURL.data.fileName
                    data.fileSuffix = "PNG"
                    uploads.append(data)
                    
                    if uploads.count == localDatas.count {
                        pics(uploads)
                    } else {
                        withAnimation(.spring()) {
                            self.uploadIndex = uploads.count
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // 上传完图片之后，将图片 URL 和其他信息一起上传
    func uploadPics(pics: [UploadData], _ success: @escaping (Bool) -> Void) {
        AF.request("\(baseURL)\(APIService.URLPath.upload.path)", method: .post, parameters: ["userPicList" : pics], encoder: JSONParameterEncoder.prettyPrinted, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"])
                    .response { response in
                    print(pics)
                    switch response.result {
                    case .success(let user):
                        success(true)
                        self.uploading = false
                    case .failure(let error):
                        print(error)
                        success(false)
                        self.error = true
                    }
                }
    }
    
    // 退出登录
    func logout() async {
        APIService.shared.POST(url: .logout, params: nil) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success(_):
                self.login = false
                self.token = ""
                APIService.token = ""
                Defaults().set("", for: .login)
            case .failure(let error):
                print("退出登录错误: \(error)")
                break
            }
        }
    }
}

