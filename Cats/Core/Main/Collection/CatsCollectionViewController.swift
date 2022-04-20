//
//  CatsCollectionViewController.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import Combine
import UIKit

final class CatsCollectionViewController: UIViewController {
    init(loadMoreSubject: PassthroughSubject<Void, Never>? = nil,
         prefetchLimit: Int) {
        self.prefetchLimit = prefetchLimit
        self.loadMoreSubject = loadMoreSubject
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSnapshot(items: [Cat]) {
        self.items = items
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cat>()
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
    private let prefetchLimit: Int
    private var items = [Cat]()
    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    private enum Section {
        case main
    }
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
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
        collectionView.register(CatCollectionCell.self, forCellWithReuseIdentifier: "MyCollectionViewCell")
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Cat> = {
        let dataSource: UICollectionViewDiffableDataSource<Section, Cat> = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self]
            collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as? CatCollectionCell
            else { fatalError("Cannot create feed cell") }
            cell.configure(with: self!.items[indexPath.row], parent: self!)
            return cell
        }
        return dataSource
    }()
}
