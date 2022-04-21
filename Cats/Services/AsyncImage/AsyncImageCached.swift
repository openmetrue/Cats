//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/13/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import SwiftUI

struct AsyncImageCached<I: View, P: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: () -> P
    private var content: (Image) -> I
    
    public init(url: String, content: @escaping (Image) -> I, placeholder: @escaping () -> P) {
        self.placeholder = placeholder
        self.content = content
        _loader = StateObject(wrappedValue: ImageLoader(url: URL(string: url), cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        if let image = loader.image {
            content(Image(uiImage: image))
        } else {
            placeholder().onAppear(perform: loader.load)
        }
    }
}
