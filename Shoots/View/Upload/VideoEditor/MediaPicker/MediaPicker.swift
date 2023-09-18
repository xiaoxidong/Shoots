//
//  File.swift
//  
//
//  Created by Ian on 27/06/2022.
//

import Foundation

/// Most of the functionallity of media Picker is Handled by the various extensions to SwiftUI.View
@available(iOS 13.0, macOS 10.15, *)
public class MediaPicker {
    
    /// This will only work in iOS as media in iOS needs to be copied to temporary directory
    public static func cleanDirectory() {
        Task {
            let directory = FileManager.default.temporaryDirectory.appendingPathComponent("MediaPicker")
            if !FileManager.default.fileExists(atPath: directory.absoluteString) {
                do {
                    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                for pathURL in directoryContents {
                    try FileManager.default.removeItem(at: pathURL)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    public static func copyContents(of url: URL, onCompletion: (URL?, Error?) -> Void) {
        do {
            let directory = FileManager.default.temporaryDirectory.appendingPathComponent("MediaPicker")
            if !FileManager.default.fileExists(atPath: directory.path) {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
            let localURL: URL = directory.appendingPathComponent(url.lastPathComponent)

            if FileManager.default.fileExists(atPath: localURL.path) {
                try? FileManager.default.removeItem(at: localURL)
            }
            try FileManager.default.copyItem(at: url, to: localURL)
            onCompletion(localURL, nil)
        } catch let catchedError {
            onCompletion(nil, catchedError)
        }
    }
}
