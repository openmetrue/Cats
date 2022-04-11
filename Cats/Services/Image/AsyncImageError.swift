//
//  AsyncImageError.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 11.04.2022.
//

import Foundation

extension AsyncImageCached {
    enum ImageServiceError: LocalizedError {
        case invalidUrl
        var errorDescription: String {
            switch self {
            case .invalidUrl:
                return "[🔧🔥] Invalid URL"
            }
        }
    }
}
