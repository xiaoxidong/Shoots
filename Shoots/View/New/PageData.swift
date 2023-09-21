//
//  PageData.swift
//  Connect
//
//  Created by XiaoDong Yuan on 2022/11/30.
//

import SwiftUI

struct PageData {
    let title: String
    let header: String
    let content: String
    let imageName: String
    let color: Color
    let textColor: Color
}

struct MockData {
    static let pages: [PageData] = [
        PageData(
            title: "",
            header: "相关的事情",
            content: "当我们做一件事情，有需要提前准备的事情，有需要后续完善的事情",
            imageName: "p1",
            color: Color(hex: "FFB4B4"),
            textColor: Color(hex: "4A4A4A")),
        PageData(
            title: "",
            header: "关联需要准备的事情",
            content: "做一件事之前我们要准备哪些事情",
            imageName: "p2",
            color: Color(hex: "FCE38A"),
            textColor: Color(hex: "4A4A4A")),
        PageData(
            title: "",
            header: "关联后续完善的事情",
            content: "做一件事之后需要完善哪些事情",
            imageName: "p3",
            color: Color(hex: "D6ADFF"),
            textColor: Color(hex: "4A4A4A")),
        PageData(
            title: "",
            header: "文本编辑器",
            content: "更好的整理每一件事项，可以是文本，是链接，是文件",
            imageName: "p4",
            color: Color(hex: "95E1D3"),
            textColor: Color(hex: "4A4A4A")),
        PageData(
            title: "",
            header: "根据 Tag 和内容进行搜索",
            content: "搜索相关内容，查看需要准备和完善的相关事情",
            imageName: "p5",
            color: Color(hex: "FFB77C"),
            textColor: Color(hex: "4A4A4A")),
        PageData(
            title: "",
            header: "iCloud 云端同步",
            content: "iPhone、iPad 和 Mac 任何地点任何时间随时查看",
            imageName: "p6",
            color: Color(hex: "EAFFD0"),
            textColor: Color(hex: "4A4A4A")),
    ]
}
