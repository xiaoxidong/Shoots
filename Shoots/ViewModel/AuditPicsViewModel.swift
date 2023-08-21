//
//  VerifyPicsViewModel.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/20.
//

import SwiftUI
import Alamofire
class AuditPicsViewModel: ObservableObject {
    @Published var auditFeed: [Audit] = []
    
    @Published var lastAuditPic: Audit? = nil
    @Published var loading = true
    // 首页第一页数据
    func getFirstPageFeed() async {
        DispatchQueue.main.async {
            self.loading = true
        }
        APIService.shared.POST(url: .auditPics, params: ["pageSize": numberPerpage, "pageNum": 1, "isAudit": "1"]) { (result: Result<AuditResponseData, APIService.APIError>) in
            switch result {
            case let .success(feeds):
                print(feeds)
                if feeds.rows.isEmpty {
                    self.loading = false
                } else {
                    self.auditFeed = feeds.rows
                }
            case let .failure(error):
                print("审核信息流第一页错误: \(error)")
            }
        }
    }
    
    func verify(audit: Audit, code: VerifyCode, _ success: @escaping (Bool) -> Void) async {
        AF.request("\(baseURL)\(APIService.URLPath.audit.path)", method: .post, parameters: ["id": audit.id, "status": "\(code.rawValue)"], encoder: JSONParameterEncoder.prettyPrinted, headers: ["Content-Type": "application/json", "Authorization": "Bearer \(APIService.token)"])
            .response { response in
                switch response.result {
                case .success:
                    success(true)
                    if let index = self.auditFeed.firstIndex(of: audit) {
                        self.auditFeed.remove(at: index)
                        if self.auditFeed.isEmpty {
                            self.loading = true
                        }
                    }
                    print(response)
                    self.lastAuditPic = audit
                case let .failure(error):
                    print(error)
                    success(false)
                }
            }
    }
    
    enum VerifyCode: Int {
        case success = 3
        case fail = 2
        case none = 1
    }
}
