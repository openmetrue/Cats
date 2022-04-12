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
        GeometryReader { geometry in
            NavigationView{
                Group {
                    switch viewModel.state {
                    case .loading:
                        Spinner()
                            .onAppear(perform: viewModel.fetchNextPageIfPossible)
                    case .search:
                        List(viewModel.breeds, id: \.id) { breed in
                            NavigationLink(destination: CatsDetail(breed: breed)){
                                Text("\(breed.name), from: \(breed.countryCode ?? "")")
                            }
                        }.id(UUID())
                    case .all:
                        CatsCollection(items: viewModel.cats, loadMoreSubject: viewModel.loadMoreSubject, prefetchLimit: viewModel.restOfCellsBeforeFetch)
                            .onReceive(viewModel.loadMoreSubject, perform: {
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
    }
}

//struct CatsMain_Previews: PreviewProvider {
//    static var previews: some View {
//        CatsMain(, selectedItem: <#Cat#>)
//    }
//}

