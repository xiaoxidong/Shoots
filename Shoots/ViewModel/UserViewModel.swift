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
    @Published var page: Int = 1
    @State var numberPerpage: Int = 12
    @Published var mostPages: Int = 1
    @Published var footerRefreshing = false
    @Published var noMore = false
    
    @Published var favoriteFeed: [Picture] = []
    
    @Published var appFeed: [Picture] = []
    
    init() {
        
    }
    // TODO: 第一次进入的时候当没网的时候，处理
    func login(appleUserId: String, identityToken: String, email: String?, fullName: String?, _ success: @escaping (Bool) -> Void) {
        print(identityToken)
        print(appleUserId)
        AF.request("\(baseURL)\(URLPath.login.path)", method: .post, parameters: ["appleUserId" : appleUserId, "identityToken" : identityToken, "email" : email ?? "", "fullName" : fullName ?? ""], encoding: JSONEncoding.default).responseDecodable(of: UserResponseData.self) { response in
            switch response.result {
            case .success(let user):
                self.login = true
                self.token = user.data.token
                Defaults().set(user.data.token, for: .login)
                success(true)
            case .failure(let error):
                print(error)
                success(false)
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
        self.noMore = false
        self.page = 1
        print(token)
        AF.request("\(baseURL)\(URLPath.feed.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : 1], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case .success(let feeds):
                print(feeds)
                self.homeFeed.append(contentsOf: feeds.rows)
                self.mostPages = feeds.total / self.numberPerpage + 1
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func nextPage() async {
        self.page += 1
        if self.page > self.mostPages {
            self.noMore = true
        } else {
            AF.request("\(baseURL)\(URLPath.feed.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : page], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).responseDecodable(of: FeedResponseData.self) { response in
                print(self.page)
                switch response.result {
                case .success(let feeds):
                    print(feeds)
                    self.homeFeed.append(contentsOf: feeds.rows)
                    withAnimation(.spring()) {
                        self.footerRefreshing = false
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func uploadPics(pics: [UploadData], _ success: @escaping (Bool) -> Void) {
        AF.request("\(baseURL)\(URLPath.upload.path)", method: .post, parameters: ["userPicList" : pics], encoder: JSONParameterEncoder.prettyPrinted, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"])
            .responseJSON { response in
            print(pics)
            switch response.result {
            case .success(let user):
                print(user)
                if let json = user as? [String: Any] {
                    print(json["msg"] as Any)
                }
                success(true)
            case .failure(let error):
                print(error)
                success(false)
            }
        }
    }
    
    
    func uploadImages(localDatas: [LocalImageData], _ pics: @escaping ([UploadData]) -> Void) {
        var uploads: [UploadData] = []
        
        localDatas.forEach { local in
//            uploads.append(await uploadImage(image: local))
            var data = UploadData(picUrl: "", compressedPicUrl: "")
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(local.image, withName: "file", fileName: "file.png", mimeType: "image/png")
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
    var favoritesPicNum: Int {
        var num = 0
        favorites.forEach { favorite in
            num += favorite.countPics
        }
        return num
    }
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
    
    @Published var app: [UploadAblumData] = []
    var appPicNum: Int {
        var num: Int = 0
        app.forEach { app in
            num += app.countPics
        }
        return num
    }
    func uploadPicGroup() async {
        AF.request("\(baseURL)\(URLPath.uploadPicGroup.path)", method: .get, headers: ["Authorization" : "Bearer \(token)"]).responseDecodable(of: UploadResponseData.self) { response in
            switch response.result {
            case .success(let favorite):
                print(favorite)
                self.app = favorite.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addFavorites(name: String) async {
        print(name)
        AF.request("\(baseURL)\(URLPath.addFavorite.path)", method: .post, parameters: ["favoriteFileName" : name], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).response { response in
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
    
    func favoritePics(id: String) async {
        AF.request("\(baseURL)\(URLPath.favoritePics.path)", method: .post, parameters: ["pageSize" : 20, "pageNum": 1, "orderByColumn": "", "isAsc": "true", "favoriteFileId": id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case .success(let feeds):
                print(feeds)
                self.favoriteFeed.append(contentsOf: feeds.rows)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removePics(pics: [String]) async {
        AF.request("\(baseURL)\(URLPath.addFavorite.path)", method: .post, parameters: ["picIds" : pics], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).response { response in
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
    
    func editFavoriteName(id: String, name: String, _ success: @escaping (Bool) -> Void) async {
        AF.request("\(baseURL)\(URLPath.editFavoriteName.path)", method: .post, parameters: ["favoriteFileId" : id, "favoriteFileName": name], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).response { response in
            switch response.result {
            case .success(let feeds):
                print(feeds)
                success(true)
            case .failure(let error):
                print(error)
                success(false)
            }
        }
    }
    
    func removeFavorite(id: [String], _ success: @escaping (Bool) -> Void) async {
        AF.request("\(baseURL)\(URLPath.removePicFromFavorite.path)", method: .post, parameters: ["picIds" : id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).response { response in
            switch response.result {
            case .success(let feeds):
                print(feeds)
                success(true)
            case .failure(let error):
                print(error)
                success(false)
            }
        }
    }
    
    func savePics(pics: [String], favoriteFileId: String) async {
        AF.request("\(baseURL)\(URLPath.addPicToFavorite.path)", method: .post, parameters: ["picIds" : pics, "favoriteFileId": favoriteFileId], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).response { response in
            switch response.result {
            case .success(_):
                print("------")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImageDetail(id: String, _ success: @escaping (ImageDetailResponseData) -> Void) async {
        AF.request("\(baseURL)\(URLPath.imageDetail.path)\(id)", method: .get, headers: ["Authorization" : "Bearer \(token)"]).responseDecodable(of: ImageDetailResponseData.self) { response in
            print(id)
            switch response.result {
            case .success(let detail):
                print(detail)
                success(detail)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAppDetail(id: String, _ success: @escaping (AppDetailResponseData) -> Void) async {
        AF.request("\(baseURL)\(URLPath.appDetail.path)\(id)", method: .get).responseDecodable(of: AppDetailResponseData.self) { response in
            switch response.result {
            case .success(let app):
                print(app)
                success(app)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func appFlows(id: String) async {
        
    }
    
    @State var appPageNumber: Int = 1
    func appPics(id: String) async {
//        appPageNumber += 1
        AF.request("\(baseURL)\(URLPath.appPics.path)", method: .post, parameters: ["pageSize" : numberPerpage, "pageNum" : appPageNumber, "orderByColumn" : "true", "isAsc" : "true", "linkApplicationId" : id], headers: ["Authorization" : "Bearer \(token)"]).responseDecodable(of: AppImageResponseData.self) { response in
            switch response.result {
            case .success(let app):
                print(app)
                self.appFeed.append(contentsOf: app.rows)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @Published var userPattern: [Pattern] = []
    func getUserPattern() async {
        AF.request("\(baseURL)\(URLPath.userPattern.path)", method: .get, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).responseDecodable(of: UserPatternResponseData.self) { response in
            switch response.result {
            case .success(let userPattern):
                print(userPattern)
                self.userPattern = userPattern.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func report(picList: [Report]) async {
        AF.request("\(baseURL)\(URLPath.report.path)", method: .post, parameters: ["picList" : picList], encoder: JSONParameterEncoder.prettyPrinted, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).response { response in
            print(picList)
            switch response.result {
            case .success(let userPattern):
                print(userPattern)
                if let json = userPattern as? [String: Any] {
                    print(json["msg"] as Any)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @Published var patternFeed: [Picture] = []
    func getPatternPics(id: String) async {
        AF.request("\(baseURL)\(URLPath.patternPics.path)", method: .post, parameters: ["pageSize" : 20, "pageNum": 1, "orderByColumn": "", "isAsc": "true", "designPatternId": id], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization" : "Bearer \(token)"]).responseDecodable(of: FeedResponseData.self) { response in
            switch response.result {
            case .success(let feeds):
                print(feeds)
                self.patternFeed.append(contentsOf: feeds.rows)
            case .failure(let error):
                print(error)
            }
        }
    }
}
