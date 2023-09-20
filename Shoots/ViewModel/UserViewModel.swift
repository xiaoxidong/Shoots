//
//  UserViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/14.
//

import Alamofire
import SwiftUI

var numberPerpage: Int = 20
var userToken = "userToken"
var group = "group.shoots.shareGroup"
class UserViewModel: ObservableObject {
    @Published var login: Bool = false {
        didSet {
            if !login {
                self.token = ""
                APIService.token = ""
                UserDefaults(suiteName: group)!.set("", forKey: userToken)
                
                isExamine = false
                isAdmin = false
            }
        }
    }
    @Published var token: String = UserDefaults(suiteName: group)!.string(forKey: userToken) ?? ""

    // 内容审核
    #if DEBUG
    @Published var isExamine = true
    @Published var isAdmin = true
    @Published var isPro = false
    #else
    @Published var isExamine = false
    @Published var isAdmin = false
    @Published var isPro = false
    #endif
    
    @Published var uploading = false
    @Published var error = false
    @Published var uploadIndex = 1
    init() {
        if UserDefaults(suiteName: group)!.string(forKey: userToken) == nil {
            UserDefaults(suiteName: group)!.set("", forKey: userToken)
        }
        login = UserDefaults(suiteName: group)!.string(forKey: userToken) == "" ? false : true
        
        if login {
            Task {
                await getInfo()
            }
        }
    }

    // 登录
    func login(appleUserId: String, identityToken: String, email: String, fullName: String, _ success: @escaping (Bool) -> Void) {
        print(email)
        print(fullName)
        print(appleUserId)
        print(identityToken)
        APIService.shared.POST(url: .login, params: ["appleUserId": appleUserId, "identityToken": identityToken, "email": email, "fullName": fullName]) { (result: Result<UserResponseData, APIService.APIError>) in
            switch result {
            case let .success(user):
                print("Token: \(user.data.token)")
                self.login = true
                self.token = user.data.token
                APIService.token = user.data.token
                UserDefaults(suiteName: group)!.set(user.data.token, forKey: userToken)
                // TODO: 登录成功之后需要判断是否有头像，如果没有则跳出编辑页面
                if user.data.userName == "" || user.data.avatar == nil {
                    self.editInfo = true
                    self.name = user.data.userName ?? ""
                    self.avatar = user.data.avatar
                }
                #if DEBUG
                self.editInfo = true
                self.name = user.data.userName ?? ""
                self.avatar = user.data.avatar
                #endif
                success(true)
                
                Task {
                    await self.getInfo()
                }
            case let .failure(error):
                print("登录报错: \(error)")
            }
        }
    }

    @Published var editInfo = false
    @Published var name: String = ""
    @Published var avatar: String? = nil
    @Published var updating = false
    func updateInfo(name: String, _ success: @escaping (Bool) -> Void) async {
        updating = true
        APIService.shared.POST(url: .updateSelfInfo, params: ["userName": name]) { (result: Result<Response, APIService.APIError>) in
            switch result {
            case .success:
                print("更新成功")
                self.editInfo = false
                success(true)
            case let .failure(error):
                print("更新信息报错: \(error)")
                success(false)
            }
        }
    }

    func uploadAvatar(image: Data, _ success: @escaping (Bool) -> Void) async {
        DispatchQueue.main.async {
            self.updating = true
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: "avatarfile", fileName: "avatarfile.png", mimeType: "image/png")
        }, to: "\(baseURL)\(APIService.URLPath.avatar.path)", method: .post, headers: ["Content-Type": "multipart/form-data", "Authorization": "Bearer \(token)"])
            .responseDecodable(of: Response.self) { response in
                switch response.result {
                case let .success(imageURL):
                    print(imageURL)
                    success(true)
                    Task {
                        await self.getInfo()
                    }
                case let .failure(error):
                    print(error)
                    success(false)
                }
            }
    }

    func getInfo() async {
        APIService.shared.GET(url: .selfInfo) { (result: Result<SelfInfoResponseData, APIService.APIError>) in
            switch result {
            case let .success(user):
                print("获取成功")
                self.name = user.data.user.userName
                self.avatar = user.data.user.avatar
                
                if let rolse = user.data.user.roles {
                    self.isExamine = !rolse.filter({ $0.roleId == Roles.examine.id }).isEmpty
                }
                if let rolse = user.data.user.roles {
                    self.isAdmin = !rolse.filter({ $0.roleId == Roles.upload.id }).isEmpty
                }
            case let .failure(error):
                print("获取信息报错: \(error)")
            }
        }
    }

    // MARK: 上传图片
    func uploadImages(localDatas: [LocalImageData], _ pics: @escaping ([UploadData]) -> Void) {
        var uploads: [UploadData] = []
        if !uploading {
            uploading = true
        }
        uploadIndex = 1
        localDatas.forEach { local in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(local.image, withName: "file", fileName: local.fileSuffix == "GIF" ? "file.gif" : "file.png", mimeType: local.fileSuffix == "GIF" ? "image/gif" :"image/png")
            }, to: "\(baseURL)\(APIService.URLPath.uploadImage.path)", method: .post, headers: ["Content-Type": "multipart/form-data", "Authorization": "Bearer \(token)"])
                .responseDecodable(of: UploadImageResponseData.self) { response in
                    switch response.result {
                    case let .success(imageURL):
                        print(imageURL)
                        var data = UploadData(picUrl: imageURL.data.url)
                        data.linkApplicationName = local.app
                        data.designPatternName = local.pattern
                        data.fileName = imageURL.data.fileName
                        data.fileSuffix = local.fileSuffix
                        data.chooseType = local.chooseType.rawValue
                        data.picDescription = local.picDescription
                        data.linkedPicId = local.linkedPicId
                        uploads.append(data)

                        if uploads.count == localDatas.count {
                            pics(uploads)
                        } else {
                            withAnimation(.spring()) {
                                self.uploadIndex = uploads.count
                            }
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
        }
    }

    // 上传完图片之后，将图片 URL 和其他信息一起上传
    func uploadPics(pics: [UploadData], _ success: @escaping (Bool) -> Void) {
        AF.request("\(baseURL)\(APIService.URLPath.upload.path)", method: .post, parameters: ["userPicList": pics], encoder: JSONParameterEncoder.prettyPrinted, headers: ["Content-Type": "application/json", "Authorization": "Bearer \(token)"])
            .response { response in
                print(pics)
                switch response.result {
                case .success:
                    success(true)
                    self.uploading = false
                case let .failure(error):
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
            case .success:
                self.login = false
            case let .failure(error):
                print("退出登录错误: \(error)")
            }
        }
    }
}
