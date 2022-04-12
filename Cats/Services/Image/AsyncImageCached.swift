//
//  AsyncImageCached.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 11.04.2022.
//

import SwiftUI
struct AsyncImageCached<I: View, P: View>: View {
    let url: URL?
    var content: (Image) -> I
    var placeholder: () -> P
    
    public init(url: URL?,
                content: @escaping (Image) -> I,
                placeholder: @escaping () -> P) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    public var body: some View {
        if let uiImage = ImageCache.shared[url!.absoluteString] {
            content(Image(uiImage: uiImage))
        } else {
            AsyncImage(url: url) { image in
                content(image)
            } placeholder: {
                placeholder()
            }
        }
    }
}
