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
                image.centerCropped()
            } placeholder: {
                ProgressView()
            }
        }
    }
}


