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
    @Published var token: String = Defaults().get(for: .login) ?? ""
    
    @Published var patterns: [Pattern] = Defaults().get(for: .localPatterns) ?? []
    @Published var apps: [Apps] = Defaults().get(for: .localApps) ?? []
    
    // 首页数据
    @Published var homeFeed: [Picture] = []
    @State var page: Int = 0
    @State var numberPerpage: Int = 20
    @Published var footerRefreshing = false
    @Published var noMore = false
    
    init() {
        
    }
    // TODO: 第一次进入的时候当没网的时候，处理
    func login(appleUserId: String, identityToken: String, email: String?, fullName: String?, _ suceess: @escaping (Bool) -> Void) {
        AF.request("\(baseURL)\(URLPath.login.path)", method: .post, parameters: ["appleUserId" : appleUserId, "identityToken" : identityToken, "email" : email ?? "834599524@qq.com", "fullName" : fullName ?? ""], encoding: JSONEncoding.default).responseDecodable(of: UserResponseData.self) { response in
            switch response.result {
            case .success(let user):
                self.login = true
                self.token = user.data.token
                Defaults().set(user.data.token, for: .login)
                suceess(true)
            case .failure(let error):
                print(error)
                suceess(false)
            }
        }
    }
    
    func getAllPatterns() async {
        AF.request("\(baseURL)\(URLPath.pattern.path)", method: .get, headers: ["Authorization" : "Bearer \(token)"]).responseDecodable(of: PatternResponseData.self) { response in
            switch response.result {
            case .success(let pattern):
                print(pattern)
                self.patterns = pattern.data
                Defaults().set(pattern.data, for: .localPatterns)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getApps() async {
        AF.request("\(baseURL)\(URLPath.apps.path)", method: .get, headers: ["Authorization" : "Bearer \(token)"]).responseDecodable(of: AppResponseData.self) { response in
            switch response.result {
            case .success(let apps):
                print(apps)
                self.apps = apps.data
                Defaults().set(apps.data, for: .localApps)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getHomeFirstPageFeed() async {
        self.homeFeed.removeAll()
        page = 1
        AF.request("\(baseURL)\(URLPath.feed.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : page], encoding: JSONEncoding.default).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case .success(let feeds):
                print(feeds)
                self.homeFeed.append(contentsOf: feeds.rows)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func nextPage() async {
        page += 1
        AF.request("\(baseURL)\(URLPath.feed.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : page], encoding: JSONEncoding.default).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case .success(let feeds):
                print(feeds)
                self.homeFeed.append(contentsOf: feeds.rows)
                withAnimation(.spring()) {
                    self.footerRefreshing = false
                    self.noMore = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func uploadPics(pics: [UploadData], _ suceess: @escaping (Bool) -> Void) {
        AF.request("\(baseURL)\(URLPath.upload.path)", method: .post, parameters: ["userPicList" : pics], encoder: JSONParameterEncoder.prettyPrinted, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"])
            .responseJSON { response in
            print(pics)
            print(["userPicList" : pics])
            switch response.result {
            case .success(let user):
                print(user)
                if let json = user as? [String: Any] {
                    print(json["msg"] as Any)
                }
                suceess(true)
            case .failure(let error):
                print(error)
                suceess(false)
            }
        }
    }
    
    
    func uploadImages(localDatas: [LocalImageData], _ pics: @escaping ([UploadData]) -> Void) {
        var uploads: [UploadData] = []
        
        localDatas.forEach { local in
//            uploads.append(await uploadImage(image: local))
            var data = UploadData(picUrl: "", compressedPicUrl: "")
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(local.image, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            }, to: "\(baseURL)\(URLPath.uploadImage.path)", method: .post, headers: ["Content-Type": "multipart/form-data", "Authorization" : "Bearer \(token)"])
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
    
    //, _ suceess: @escaping (UploadData) -> Void
    @MainActor
    func uploadImage(image: LocalImageData) async -> UploadData {
        var data = UploadData(picUrl: "", compressedPicUrl: "")
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.image, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: "\(baseURL)\(URLPath.uploadImage.path)", method: .post, headers: ["Content-Type": "multipart/form-data", "Authorization" : "Bearer \(token)"])
            .responseDecodable(of: UploadImageResponseData.self) { response in
            switch response.result {
            case .success(let imageURL):
                print(imageURL)
                data.linkApplicationName = image.app
                data.designPatternName = image.pattern
                data.picUrl = imageURL.data.url
                data.compressedPicUrl = imageURL.data.compressedUrl
                data.fileName = imageURL.data.fileName
                data.fileSuffix = "PNG"
            case .failure(let error):
                print(error)
            }
        }
        
        return data
    }
    
    @Published var favorites: [FavoriteData] = []
    func getFavorites() async {
        AF.request("\(baseURL)\(URLPath.allFavorite.path)", method: .get, headers: ["Authorization" : "Bearer \(token)"]).responseDecodable(of: FavoriteResponseData.self) { response in
            switch response.result {
            case .success(let favorite):
                print(favorite)
                self.favorites = favorite.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addFavorites(name: String) async {
        AF.request("\(baseURL)\(URLPath.addFavorite.path)", method: .post, parameters: ["favoriteFileName" : name], headers: ["Authorization" : "Bearer \(token)"]).response { response in
            switch response.result {
            case .success(_):
                self.favorites.removeAll()
                Task {
                    await self.getFavorites()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImageDetail(id: String, _ suceess: @escaping (ImageDetailResponseData) -> Void) async {
        AF.request("\(baseURL)\(URLPath.imageDetail.path)\(id)", method: .get, headers: ["Authorization" : "Bearer \(token)"]).responseDecodable(of: ImageDetailResponseData.self) { response in
            switch response.result {
            case .success(let detail):
                print(detail)
                suceess(detail)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAppDetail(id: String, _ suceess: @escaping (AppDetailResponseData) -> Void) async {
        AF.request("\(baseURL)\(URLPath.appDetail.path)\(id)", method: .get).responseDecodable(of: AppDetailResponseData.self) { response in
            switch response.result {
            case .success(let app):
                print(app)
                suceess(app)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @State var appPageNumber: Int = 0
    func appPics(id: String) async {
        appPageNumber += 1
        AF.request("\(baseURL)\(URLPath.appPics.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : appPageNumber, "orderByColumn" : "true", "isAsc" : "true", "linkApplicationId" : id], headers: ["Authorization" : "Bearer \(token)"]).responseDecodable(of: AppImageResponseData.self) { response in
            switch response.result {
            case .success(let app):
                print(app)
            case .failure(let error):
                print(error)
            }
        }
    }
}
