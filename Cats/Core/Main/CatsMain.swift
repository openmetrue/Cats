//
//  CatsMain.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI

struct CatsMain: View {
    @StateObject var viewModel = CatsMainViewModel()
    var body: some View {
        NavigationView{
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .onAppear(perform: viewModel.fetchNextPageIfPossible)
                case .search:
                    List(viewModel.breeds, id: \.id) { breed in
                        NavigationLink(destination: CatsDetail(breed: breed)){
                            Text("\(breed.name), from: \(breed.countryCode ?? "")")
                        }
                    }.id(UUID())
                case .all:
                    CollectionView(items: viewModel.cats, prefetchLimit: viewModel.restOfCellsBeforeFetch, loadMoreSubject: viewModel.loadMoreSubject) { indexPath, item in
                        cell(for: item, at: indexPath)
                    }.onReceive(viewModel.loadMoreSubject, perform: {
                        self.viewModel.fetchNextPageIfPossible()
                    })
                case .error(let error):
                    Text(error)
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Сat's observer")
            .environment(\.disableAutocorrection, true)
        }
    }
    func cell(for item: Cat, at indexPath: IndexPath) -> some View {
        CatsCell(item: item)
    }
}

//struct CatsMain_Previews: PreviewProvider {
//    static var previews: some View {
//        CatsMain(, selectedItem: сat)
//    }
//}

