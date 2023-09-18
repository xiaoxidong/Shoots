//
//  File.swift
//  
//
//  Created by Ian on 29/06/2022.
//

import UniformTypeIdentifiers

@available(iOS 14.0, macOS 11, *)
public struct MediaTypeOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let livePhotos = MediaTypeOptions(rawValue: 1 << 0)
    public static let images: MediaTypeOptions = [MediaTypeOptions(rawValue: 1 << 1), livePhotos]
    public static let videos = MediaTypeOptions(rawValue: 1 << 2)
    
    /// All media types.
    public static let all: MediaTypeOptions = [.images, .videos]
    
    /// All uniform type identifiers for contained media types.
    internal var typeIdentifiers: [UTType] {
        var types = [UTType]()
        if contains(.images) {
            types.append(.image)
        } else if contains(.livePhotos) {
            types.append(.livePhoto)
        }
        if contains(.videos) {
            types.append(.audiovisualContent)
        }
        return types
    }
}

