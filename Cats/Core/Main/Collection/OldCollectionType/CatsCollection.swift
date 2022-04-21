//
//  CatsCollection.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI
import Combine

struct CatsCollection<Item: Hashable, Cell: View>: UIViewControllerRepresentable {
    private var items: [Item]
    private let prefetchLimit: Int
    private let cell: (IndexPath, Item) -> Cell
    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    
    public init(items: [Item], prefetchLimit: Int, loadMoreSubject: PassthroughSubject<Void, Never>? = nil, @ViewBuilder cell: @escaping (IndexPath, Item) -> Cell) {
        self.items = items
        self.prefetchLimit = prefetchLimit
        self.loadMoreSubject = loadMoreSubject
        self.cell = cell
    }

    func makeUIViewController(context _: Context) -> CatsCollectionViewController<Item, Cell> {
        CatsCollectionViewController(prefetchLimit: prefetchLimit, loadMoreSubject: loadMoreSubject, cell: cell)
    }

    func updateUIViewController(_ view: CatsCollectionViewController<Item, Cell>, context _: Context) {
        view.updateSnapshot(items: items)
    }
}
