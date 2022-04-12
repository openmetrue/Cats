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
            if let imagebase64 = cat.image,
               let data = Data(base64Encoded: imagebase64),
               let uiimage = UIImage(data: data),
               let image = Image(uiImage: uiimage) {
                image
                    .centerCropped()
            } else {
                AsyncImageCached(url: URL(string: cat.url!)) { image in
                    image
                        .centerCropped()
                } placeholder: {
                    Spinner()
                }.padding()
            }
            List {
                Text("Cat's ID: \(cat.id!)")
                Text("Photo: \(cat.width)x\(cat.height)")
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
            } .id(UUID())
        }
    }
}

