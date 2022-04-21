//
//  CatsCollection.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI
import Combine

struct CatsCollection: UIViewControllerRepresentable {
    private var items: [Cat]
    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    private let prefetchLimit: Int
    init(items: [Cat], loadMoreSubject: PassthroughSubject<Void, Never>? = nil, prefetchLimit: Int = 10) {
        self.items = items
        self.loadMoreSubject = loadMoreSubject
        self.prefetchLimit = prefetchLimit
    }

    func makeUIViewController(context _: Context) -> CatsCollectionViewController {
        CatsCollectionViewController(loadMoreSubject: loadMoreSubject, prefetchLimit: prefetchLimit)
    }

    func updateUIViewController(_ view: CatsCollectionViewController, context _: Context) {
        view.updateSnapshot(items: items)
    }
}
