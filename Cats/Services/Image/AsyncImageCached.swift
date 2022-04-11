//
//  AsyncImageCached.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 11.04.2022.
//

import SwiftUI
struct AsyncImageCached<I: View, P: View>: View {
    @State var uiImage: UIImage?
    let url: URL?
    var content: (Image) -> I
    var placeholder: () -> P
    public init(url: URL?, content: @escaping (Image) -> I, placeholder: @escaping () -> P) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    var body: some View {
        ZStack {
            if let uiImage = uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        .task {
            do {
                try await getImage(url: url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func getImage(url: URL?) async throws {
        guard let url = url else {
            self.uiImage = UIImage()
            throw ImageServiceError.invalidUrl
        }
        let urlString = url.absoluteString
        if let uiImage = ImageCache.shared[urlString] {
            self.uiImage = uiImage
        } else {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let uiImage = UIImage(data: data)
                ImageCache.shared[urlString] = uiImage
                self.uiImage = uiImage
            } catch {
                throw error
            }
        }
    }
}

