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
        APIService.shared.POST(url: .upload, params: ["userPicList" : pics]) { (result: Result<FeedResponseData, APIService.APIError>) in
            switch result {
            case .success(let feeds):
               print("success")
            case .failure(let error):
                print("api reqeust erro: \(error)")
                break
            }
        }
    }
    
    // MARK: 上传图片
    func uploadImages(localDatas: [LocalImageData], _ pics: @escaping ([UploadData]) -> Void) {
        var uploads: [UploadData] = []
        
        localDatas.forEach { local in
            var data = UploadData(picUrl: "", compressedPicUrl: "")
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(local.image, withName: "file", fileName: "file.png", mimeType: "image/png")
            }, to: "\(baseURL)\(APIService.URLPath.uploadImage.path)", method: .post, headers: ["Content-Type": "multipart/form-data", "Authorization" : "Bearer \(token)"])
                .responseDecodable(of: UploadImageResponseData.self) { response in
                switch response.result {
                case .success(let imageURL):
                    print(imageURL)
                    data.linkApplicationName = local.app
                    data.designPatternName = local.pattern
                    data.picUrl = imageURL.data.url
                    data.compressedPicUrl = imageURL.data.compressedUrl
                    data.fileName = imageURL.data.fileName
                    data.fileSuffix = "PNG"
                    uploads.append(data)
                    
                    if uploads.count == localDatas.count {
                        pics(uploads)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
