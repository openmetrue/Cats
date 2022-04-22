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
        NavigationView{
            Group {
                switch viewModel.state {
                case .empty:
                    VStack {
                        Text("Empty")
                        Text("add first cat to saved")
                    }
                case .loaded(let catsDB):
                    UIKitCollection(items: catsDB) { indexPath, item in Group {
                        NavigationLink(destination: CatsFavoriteDetail(cat: item)) {
                            if let imageData = item.image,
                               let uiimage = UIImage(data: imageData),
                               let image = Image(uiImage: uiimage) {
                                image.centerCropped()
                            }
                        }
                    }}
                    .toolbar {
                        Button {
                            viewModel.deleteAll()
                        } label: {
                            Text("Empty saved")
                        }
                    }
                case .error(let error):
                    Text(error)
                case .loading:
                    ProgressView()
                }
            }
            .onAppear { viewModel.fetchCats() }
            .navigationBarTitle("Saved cat's", displayMode: .inline)
        }
    }
}
