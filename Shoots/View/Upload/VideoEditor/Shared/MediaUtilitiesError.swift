//
//  MediaUtilitiesError.swift
//  
//
//  Created by Ian on 08/12/2022.
//

import Foundation

enum MediaUtilitiesError: LocalizedError {
    case isGuarded
    case lacksConformingTypeIdentifiers
    case lacksAudioVisualContent
    case badImage

    public var errorDescription: String? {
        let base = "The operation could not be completed. "
        switch self {
        case .isGuarded:
            return base + "The DropDelegate is guarded"
        case .lacksConformingTypeIdentifiers:
            return base + "The Drop Item Does Not Conform to The Type Identifiers Provided"
        case .lacksAudioVisualContent:
            return base + "The Drop Item is Not an AudioVisual Content, it is not playable"
        case .badImage:
            return base + "Failed to get Image from data"
        }
    }
}
