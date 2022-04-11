//
//  CatsFavoriteDetail.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI

struct CatsFavoriteDetail: View {
    let cat: CatDB
    var body: some View {
        VStack {
            AsyncImageCached(url: URL(string: cat.url!)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .clipped()
            } placeholder: {
                Spinner()
            }.padding()
            List {
                Text("Cat's ID: \(cat.id!)")
                if let categories = cat.categoryDB,
                   categories != [] {
                    Section(header: Text("Category")) {
                        ForEach(Array(categories as? Set<CategoryDB> ?? [])) { category in
                            Text(category.name!)
                        }
                    }
                }
                if let breeds = cat.breedDB,
                   breeds != [] {
                    Section(header: Text("Breed")) {
                        ForEach(Array(breeds as? Set<BreedDB> ?? [])) { breed in
                            if let name = breed.name {
                                Text("\(name)")
                            }
                            if let breedDescription = breed.breedDescription {
                                Text("\(breedDescription)")
                            }
                        }
                    }
                }
                Text("Photo: \(cat.width)x\(cat.height)")
            } .id(UUID())
        }
    }
}

