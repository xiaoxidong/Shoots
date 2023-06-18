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
    @Published var login = Defaults().get(for: .login) == nil ? false : true
    @Published var token: String = Defaults().get(for: .login) ?? ""
    
    @Published var uploading = false
    @Published var error = false
    @Published var uploadIndex = 1
    // TODO: 第一次进入的时候当没网的时候，处理
    func login(appleUserId: String, identityToken: String, email: String, fullName: String, _ success: @escaping (Bool) -> Void) {
        APIService.shared.POST(url: .login, params: ["appleUserId" : appleUserId, "identityToken" : identityToken, "email" : email, "fullName" : fullName]) { (result: Result<UserResponseData, APIService.APIError>) in
            switch result {
            case .success(let user):
                self.login = true
                self.token = user.data.token
                Defaults().set(user.data.token, for: .login)
                success(true)
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    func uploadPics(pics: [UploadData], _ success: @escaping (Bool) -> Void) {
        AF.request("\(baseURL)\(APIService.URLPath.upload.path)", method: .post, parameters: ["userPicList" : pics], encoder: JSONParameterEncoder.prettyPrinted, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"])
                    .responseJSON { response in
                    print(pics)
                    switch response.result {
                    case .success(let user):
                        print(user)
                        if let json = user as? [String: Any] {
                            print(json["msg"] as Any)
                        }
                        success(true)
                        self.uploading = false
                    case .failure(let error):
                        print(error)
                        success(false)
                        self.error = true
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
                    var data = UploadData(picUrl: imageURL.data.url, compressedPicUrl: imageURL.data.compressedUrl)
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
}

