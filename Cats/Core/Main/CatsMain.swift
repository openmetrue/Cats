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
        NavigationView {
            VStack(spacing: 0) {
                SearchField(text: $viewModel.searchText)
                Group {
                    switch viewModel.state {
                    case .loading:
                        Spacer()
                        ProgressView()
                            .onAppear(perform: viewModel.fetchNextPageIfPossible)
                        Spacer()
                    case .search:
                        List(viewModel.breeds, id: \.id) { breed in
                            NavigationLink(destination: CatsDetail(breed: breed)){
                                Text("\(breed.name), from: \(breed.countryCode ?? "")")
                            }
                        }.id(UUID())
                    case .all:
                        UIKitCollection(items: viewModel.cats, prefetchLimit: viewModel.restOfCellsBeforeFetch, loadMoreSubject: viewModel.loadMoreSubject, pullToRefreshSubject: viewModel.pullToRefreshSubject) { indexPath, item in CatsCell(item: item, index: indexPath.row) }
                            .onReceive(viewModel.loadMoreSubject) {
                                self.viewModel.fetchNextPageIfPossible()
                            }
                            .onReceive(viewModel.pullToRefreshSubject) {
                                self.viewModel.refreshItems()
                            }
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                    case .error(let error):
                        Spacer()
                        Text(error)
                        Spacer()
                    }
                }
            }
            
            //.searchable(text: $viewModel.searchText)
            .navigationTitle("Сat's observer")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.disableAutocorrection, true)
        }
    }
}

//struct CatsMain_Previews: PreviewProvider {
//    static var previews: some View {
//        CatsMain(, selectedItem: сat)
//    }
//}

