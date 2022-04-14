//
//  CatsMainCell.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI

struct CatsCell: View {
    var item: Cat
    var body: some View {
        NavigationLink {
            CatsDetail(cat: item)
        } label: {
            AsyncImage(url: URL(string: item.url)) { image in
                image
                    .centerCropped()
            } placeholder: {
                ProgressView()
            }
        }
    }
}

class CatCollectionCell: CollectionViewEmbed<CatsCell> {
    func configure(with content: Cat, parent: UIViewController) {
        embed(in: parent, withView: CatsCell(item: content))
        controller?.view.frame = self.contentView.bounds
    }
}


