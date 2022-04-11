//
//  CatsMain.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI

struct CatsMain: View {
    @ObservedObject var viewModel = CatsMainViewModel()
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                Group {
                    switch viewModel.state {
                    case .search:
                        List(viewModel.breeds, id: \.id) { breed in
                            NavigationLink(destination: CatsDetail(breed: breed)){
                                Text("\(breed.name), from: \(breed.countryCode ?? "")")
                            }
                        }.id(UUID())
                    case .all:
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)) {
                                ForEach(viewModel.cats, id: \.id) { cat in
                                    NavigationLink(destination: CatsDetail(cat: cat)){
                                        AsyncImageCached(url: URL(string: cat.url), content: { image in
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
                                        .onAppear {
                                            if viewModel.cats.last == cat {
                                                viewModel.fetchNextPageIfPossible()
                                            }
                                        }
                                    }
                                }
                            } .padding(.horizontal)
                        }
                    case .error(let error):
                        Text(error)
                    }
                }
                .onAppear(perform: viewModel.fetchNextPageIfPossible)
                .searchable(text: $viewModel.searchText)
                .navigationTitle("Сat's observer")
                .environment(\.disableAutocorrection, true)
            }
        }
    }
}

struct CatsMain_Previews: PreviewProvider {
    static var previews: some View {
        CatsMain()
    }
}

