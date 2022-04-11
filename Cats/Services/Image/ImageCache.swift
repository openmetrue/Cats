//
//  ImageCache.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 11.04.2022.
//

import UIKit

class ImageCache: NSCache<NSString, UIImage> {
    static let shared = ImageCache()
    subscript(key: String) -> UIImage? {
        get {
            return object(forKey: NSString(string: key))
        }
        set {
            if let newValue = newValue {
                setObject(newValue, forKey: NSString(string: key))
            } else {
                removeObject(forKey: NSString(string: key))
            }
        }
    }
}
