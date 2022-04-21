//
//  CatsMainCell.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI
import NukeUI

struct CatsCell: View {
    var item: Cat
    var body: some View {
        NavigationLink {
            CatsDetail(cat: item)
        } label: {
            LazyImage(source: item.url) { state in
                if let image = state.image {
                    image
                } else if state.error != nil {
                    Color.clear// Indicates an error.
                } else {
                    ProgressView()
                }
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


