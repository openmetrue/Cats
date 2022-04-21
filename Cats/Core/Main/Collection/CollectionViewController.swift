//
//  CatsCollectionViewController.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import Combine
import SwiftUI

final class CollectionViewController<Item: Hashable, Cell: View>: UIViewController {
    private var items = [Item]()
    private let prefetchLimit: Int
    private let cellIdentifier = "hostCell"
    private let cell: (IndexPath, Item) -> Cell
    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    
    public init(prefetchLimit: Int, loadMoreSubject: PassthroughSubject<Void, Never>? = nil, @ViewBuilder cell: @escaping (IndexPath, Item) -> Cell) {
        self.prefetchLimit = prefetchLimit
        self.loadMoreSubject = loadMoreSubject
        self.cell = cell
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSnapshot(items: [Item]) {
        self.items = items
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private enum Section {
        case main
    }
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.visibleItemsInvalidationHandler = {
            [weak self] visibleItems, _, _ in
            guard let self = self,
                  let row = visibleItems.last?.indexPath.row else { return }
            if self.items.count - self.prefetchLimit > 0,
               row >= self.items.count - self.prefetchLimit {
                self.loadMoreSubject?.send()
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HostCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let dataSource: UICollectionViewDiffableDataSource<Section, Item> = UICollectionViewDiffableDataSource(collectionView: collectionView)
        { [self] collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? HostCell
            else { fatalError("Cannot create feed cell") }
            cell.hostedCell = self.cell(indexPath, (self.items[indexPath.row]))
            return cell
        }
        return dataSource
    }()
    
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


