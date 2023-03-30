//
//  Bundle+Extension.swift
//  Poke
//
//  Created by XiaoDong Yuan on 2021/7/4.
//

import SwiftUI
#if os(macOS)
import Cocoa
#endif
import os.log

fileprivate let logger = Logger(subsystem: "Uberabout", category: "")

// MARK: - Bundle Extension
extension Bundle {
    var appName: String {
        if let name = self.infoDictionary?["CFBundleName"] as? String {
            return name
        } else {
            logger.debug("Unable to determine 'appName'")
            return ""
        }
    }
    
    static var appName: String {
        if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        } else {
            logger.debug("Unable to determine 'appName'")
            return ""
        }
    }
    
    static var appVersionMarketing: String {
        if let name = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return name
        } else {
            logger.debug("Unable to determine 'appVersionMarketing'")
            return ""
        }
    }
    
    static var appVersionBuild: String {
        let bundleKey = kCFBundleVersionKey as String
        if let version = Bundle.main.object(forInfoDictionaryKey: bundleKey) as? String {
            return version
        } else {
            logger.debug("Unable to determine 'appVersionBuild'")
            return "0"
        }
    }
    
    static var copyrightHumanReadable: String {
        if let name = Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String {
            return name
        } else {
            logger.debug("Unable to determine 'copyrightHumanReadable'")
            return ""
        }
    }
}
