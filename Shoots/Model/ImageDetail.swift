//
//  ImageDetailResponseData.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/29.
//

import SwiftUI
/*
Optional({
    appStoreId = "<null>";
    avatar = "https://shoot-dev.oss-cn-beijing.aliyuncs.com/avatar/1683139664814309377/2023/08/20/8b7db69c1aed403594c5fb47414a9569.png";
    chooseType = "<null>";
    designPatternList =     (
    );
    favoriteNum = 1;
    fileName = "file.png";
    fileSuffix = PNG;
    id = 1693516372768501761;
    isFavorite = 0;
    linkApplicationId = 1693516372747530241;
    linkApplicationName = "\U770b\U770b";
    linkApplicationOfficialId = "<null>";
    picDescription = "<null>";
    picUrl = "https://shoot-dev.oss-cn-beijing.aliyuncs.com/pics/1683139664814309377/2023/08/21/3856f8995b9a45e281c65e37e0af9899.png";
    uploadNum = 28;
    userId = 1683139664814309377;
    userName = "Poke Design";
})
*/
struct ImageDetail: Codable {
    var id: String
    var picUrl: String
    var linkApplicationId: String?
    var linkApplicationOfficialId: String?
    var fileName: String
    var fileSuffix: String
    var linkApplicationName: String?
    var appStoreId: String?
    var description: String?
    var appUrl: String?
    var appLogoUrl: String?
    var isFavorite: Int?
    var userName: String?
    var avatar: String?
    var uploadNum: String
    var favoriteNum: String
    var designPatternList: [PatternName]
//    var chooseType: String?
//    var picDescription: String
    
//    var lists: [PatternName] {
//        var new = designPatternList
//        new.insert(PatternName(id: "", designPatternName: "最近更新", type: "type"), at: 0)
//        return new
//    }

    struct PatternName: Codable, Identifiable, Hashable {
        var id: String
        var designPatternName: String
        var type: String?
    }
}
