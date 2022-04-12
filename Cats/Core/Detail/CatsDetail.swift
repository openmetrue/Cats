//
//  CatsDetail.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI

struct CatsDetail: View {
    @ObservedObject var viewModel: CatsDetailViewModel
    init(breed: Breedes) {
        self.viewModel = CatsDetailViewModel(breed: breed)
    }
    init(cat: Cat) {
        self.viewModel = CatsDetailViewModel(cat: cat)
    }
    var body: some View {
        switch viewModel.state {
        case .loaded(let cat):
            Group {
                VStack {
                    AsyncImageCached(url: URL(string: cat.url)) { image in
                        image.centerCropped()
                            .toolbar {
                                Button {
                                    viewModel.save(cat, image: image)
                                } label: {
                                    Text("Save to offline")
                                        .foregroundColor(viewModel.saved ? Color.secondary : Color.accentColor)
                                }
                            }
                    } placeholder: {
                        Spinner()
                    }.padding()
                    List {
                        Text("Cat's ID: \(cat.id)")
                        Text("Photo: \(cat.width)x\(cat.height)")
                        if let categories = cat.categories {
                            Section(header: Text("Category")) {
                                ForEach(categories, id: \.id) { category in
                                    Text(category.name)
                                }
                            }
                        }
                        if let breeds = cat.breeds,
                            breeds != [] {
                            Section(header: Text("Breed")) {
                                ForEach(breeds, id: \.id) { breed in
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
        case .loading:
            Spinner()
        case .error(let error):
            Text(error)
        }
    }
}

//struct CatsDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        CatsDetail(breed: "")
//    }
//}
