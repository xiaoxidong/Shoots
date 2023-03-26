//
//  String+Extension.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
    
    // 汉子转换成小写的拼音字母
    func transToLowercasedPinYin() -> String {
        //转化为可变字符串
        let mString = NSMutableString(string: self)
        
        //转化为带声调的拼音
        CFStringTransform(mString, nil, kCFStringTransformToLatin, false)
        
        //转化为不带声调
        CFStringTransform(mString, nil, kCFStringTransformStripDiacritics, false)
        
        //转化为不可变字符串
        let string = NSString(string: mString)
        
        //去除字符串之间的空格
        return string.replacingOccurrences(of: " ", with: "").lowercased()
    }
}
