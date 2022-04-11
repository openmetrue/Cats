//
//  CatsFavorite.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI

struct CatsFavorite: View {
    @ObservedObject var viewModel = CatsFavoriteViewModel()
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                Group {
                    switch viewModel.state {
                    case .empty:
                        VStack {
                            Text("Empty")
                            Text("add first cat to saved")
                        }
                    case .loaded(let catsDB):
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)) {
                                ForEach(catsDB, id: \.id) { cat in
                                    AsyncImageCached(url: URL(string: cat.url!), content: { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15, alignment: .center)
                                                .cornerRadius(3)
                                                .clipped()
                                        }, placeholder: {
                                            Spinner()
                                                .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15, alignment: .center)
                                        })
                                    Text("Cat's ID: \(cat.id)")
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
                                    Text("Photo: \(cat.width)x\(cat.height)")
                                }
                            } .padding(.horizontal)
                        } .toolbar {
                            Button("Delete saved") {
                                viewModel.deleteAll()
                            }
                        }
                    case .error(let error):
                        Text(error)
                    case .loading:
                        Spinner()
                    }
                }
                .onAppear {
                    viewModel.fetchCats()
                }
                .navigationTitle("Saved cat's")
            }
        }
    }
}

struct CatsFavorite_Previews: PreviewProvider {
    static var previews: some View {
        CatsFavorite()
    }
}
