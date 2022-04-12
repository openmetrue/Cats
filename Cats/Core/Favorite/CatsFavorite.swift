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
                                    NavigationLink(destination: CatsFavoriteDetail(cat: cat)) {
                                        if let imagebase64 = cat.image,
                                           let data = Data(base64Encoded: imagebase64),
                                           let uiimage = UIImage(data: data),
                                           let image = Image(uiImage: uiimage) {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15, alignment: .center)
                                        } else {
                                            AsyncImageCached(url: URL(string: cat.url!)) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15, alignment: .center)
                                            } placeholder: {
                                                Spinner()
                                            }.padding()
                                        }
                                    }
                                }
                            } .padding(.horizontal)
                        } .toolbar {
                            Button {
                                viewModel.deleteAll()
                            } label: {
                                Text("Empty saved")
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
