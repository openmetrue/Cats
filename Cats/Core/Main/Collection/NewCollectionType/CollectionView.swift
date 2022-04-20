//
//  CollectionView.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 20.04.2022.
//

import SwiftUI
import Combine

import SwiftUI

struct CollectionView<Item: Hashable, Cell: View>: UIViewRepresentable {
    private var items: [Item]
    private let prefetchLimit: Int
    private let cell: (IndexPath, Item) -> Cell
    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    public init(
        items: [Item],
        prefetchLimit: Int,
        loadMoreSubject: PassthroughSubject<Void, Never>? = nil,
        @ViewBuilder cell: @escaping (IndexPath, Item) -> Cell
    ) {
        self.items = items
        self.prefetchLimit = prefetchLimit
        self.loadMoreSubject = loadMoreSubject
        self.cell = cell
    }
    func makeUIView(context: Context) -> UICollectionView {
        let cellIdentifier = "hostCell"
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout()
        )
        
        collectionView.delegate = context.coordinator
        collectionView.register(
            HostCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )
        
        let dataSource = Coordinator.DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let hostCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: cellIdentifier,
                    for: indexPath
                ) as? HostCell
                hostCell?.hostedCell = cell(indexPath, item)
                return hostCell
            }
        )
        
        addDataSourceToCoordinator(dataSource: dataSource, in: context)
        reloadData(in: collectionView, in: context, items: items)
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        reloadData(in: uiView, in: context, items: items, animated: true)
    }
    
}
// MARK: - Layout
extension CollectionView {
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.visibleItemsInvalidationHandler = { visibleItems, _, _ in
            guard let row = visibleItems.last?.indexPath.row else { return }
            if self.items.count - self.prefetchLimit > 0,
               row >= self.items.count - self.prefetchLimit {
                self.loadMoreSubject?.send()
                print("погнали")
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
    func reloadData(in collectionView: UICollectionView, in context: Context, items: [Item], animated: Bool = false) {
        let coordinator = context.coordinator
        guard let dataSource = coordinator.dataSource else { return }
        
        self.items = items
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Coordinator Creation
extension CollectionView {
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UICollectionViewDelegate {
        var parent: CollectionView
        fileprivate typealias DataSource = UICollectionViewDiffableDataSource<CollectionView.Sections, Item>
        fileprivate var dataSource: DataSource? = nil
        
        init(parent: CollectionView) {
            self.parent = parent
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            //parent.selectedIndexPath = indexPath.item
            print(indexPath.item)
        }
    }
}

// MARK: - Data Source
extension CollectionView {
    func addDataSourceToCoordinator(dataSource: UICollectionViewDiffableDataSource<Sections, Item>, in context: Context) {
        context.coordinator.dataSource = dataSource
    }
}

// MARK: - Cell (wrapped SwiftUI View)
extension CollectionView {
    private class HostCell: UICollectionViewCell {
        private var hostController: UIHostingController<Cell>?
        
        override func prepareForReuse() {
            if let hostView = hostController?.view {
                hostView.removeFromSuperview()
            }
            hostController = nil
        }
        
        var hostedCell: Cell? {
            willSet {
                guard let view = newValue else { return }
                // ignoring safe area here to avoid a weird bug with
                // wrong sizing of some items.
                hostController = UIHostingController(rootView: view, ignoreSafeArea: true)
                if let hostView = hostController?.view {
                    hostView.frame = contentView.bounds
                    hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    contentView.addSubview(hostView)
                }
            }
        }
    }
}
