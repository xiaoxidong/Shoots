//
//  APIService.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/14.
//

import Alamofire
import SwiftUI

struct APIService {
    public static let shared = APIService()

    public static var token: String = Defaults().get(for: .login) ?? ""

    public enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }

    enum URLPath {
        case login
        case feed
        case pattern
        case apps
        case allFavorite
        case addFavorite
        case addPicToFavorite
        case removePicFromFavorite
        case favoritePics
        case editFavoriteName
        case deleteFavorite
        case upload
        case uploadImage
        case deleteImage
        case imageDetail(id: String)
        case appDetail(id: String)
        case appPics
        case userPattern
        case uploadPicGroup
        case patternPics
        case report
        case searchPattern
        case logout
        case selfAppPic
        case selfPatternPic
        case updateSelfInfo

        var path: String {
            switch self {
            case .login:
                return "/app/login"
            case .pattern:
                return "/app/pattern/list"
            case .apps:
                return "/app/application/list"
            case .allFavorite:
                return "/app/favorite/list"
            case .addFavorite:
                return "/app/favorite/add"
            case .addPicToFavorite:
                return "/app/pic/bookmark"
            case .removePicFromFavorite:
                return "/app/pic/unBookmark"
            case .favoritePics:
                return "/app/favorite/pics"
            case .editFavoriteName:
                return "/app/favorite/update"
            case .deleteFavorite:
                return "/app/favorite/delete/"
            case .feed:
                return "/app/pic/feed"
            case .upload:
                return "/app/pic/upload"
            case .uploadImage:
                return "/system/oss/upload"
            case .deleteImage:
                return "/app/pic/delete"
            case let .imageDetail(id):
                return "/app/pic/detail/\(id)"
            case let .appDetail(id):
                return "/app/application/detail/\(id)"
            case .appPics:
                return "/app/application/pics"
            case .userPattern:
                return "/app/pattern/pattern"
            case .uploadPicGroup:
                return "/app/application/group"
            case .patternPics:
                return "/app/pic/pageByPatternId"
            case .report:
                return "/app/pic/report"
            case .searchPattern:
                return "/app/pic/pageByPatternName"
            case .logout:
                return "/app/logout"
            case .selfAppPic:
                return "/app/application/picsForProfile"
            case .selfPatternPic:
                return "/app/pic/pageByPatternIdForProfile"
            case .updateSelfInfo:
                return "/app/user/profile/updateProfile"
            }
        }
    }

    public func POST<T: Codable>(url: URLPath, params: [String: Any]?, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        print(APIService.token)
        AF.request("\(baseURL)\(url.path)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization": "Bearer \(APIService.token)"]).responseDecodable(of: T.self) { response in
            switch response.result {
            case let .success(object):
                completionHandler(.success(object))
            case let .failure(error):
                print(error)
                completionHandler(.failure(.jsonDecodingError(error: error)))
            }
        }
    }

    public func GET<T: Codable>(url: URLPath, params: [String: String]?, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        AF.request("\(baseURL)\(url.path)", method: .get, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Authorization": "Bearer \(APIService.token)"]).responseDecodable(of: T.self) { response in
            switch response.result {
            case let .success(object):
                completionHandler(.success(object))
            case let .failure(error):
                print(error)
                completionHandler(.failure(.jsonDecodingError(error: error)))
            }
        }
    }
}
