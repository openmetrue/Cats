//
//  CatsDetailViewModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import Foundation
import Combine
import SwiftUI

final class CatsDetailViewModel: ObservableObject {
    @Published private(set) var state: CatsDetailViewState = .loading
    @Published private(set) var saved: Bool = false
    private var bag = Set<AnyCancellable>()
    public init(cat: Cat) {
        self.state = .loaded(cat)
    }
    public init(breed: Breedes) {
        loadCat(id: breed.referenceImageID ?? "hBXicehMA")
    }
    
    public func loadCat(id: String) {
        API.getCatsFromID(id)
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                }
            }, receiveValue: {
                self.state = .loaded($0)
            }).store(in: &bag)
    }
    
    public func save(_ cat: Cat) {
        guard !saved else { return }
        let action: (() -> Void) = {
            let catDB: CatDB = CDAPI.createEntity()
            catDB.unicID = UUID()
            catDB.id = cat.id
            catDB.url = cat.url
            catDB.width = Int64(cat.width)
            catDB.height = Int64(cat.height)
            
            //if let uiImage = self.cache[URL(string: cat.url)!] {
            //    catDB.image = uiImage.jpegData(compressionQuality: 1)
            //    print("saved from cache")
            // }
            //else {
            catDB.image = try? Data(contentsOf: URL(string: cat.url)!)
            //}
            var breedsDB: [BreedDB] = []
            for breed in cat.breeds {
                let breedDB: BreedDB = CDAPI.createEntity()
                breedDB.id = breed.id
                breedDB.name = breed.name
                breedDB.breedDescription = breed.breedDescription
                breedsDB.append(breedDB)
            }
            var categoriesDB: [CategoryDB] = []
            if let categories = cat.categories {
                for category in categories {
                    let categoryDB: CategoryDB = CDAPI.createEntity()
                    categoryDB.id = Int64(category.id)
                    categoryDB.name = category.name
                    categoriesDB.append(categoryDB)
                }
            }
            catDB.breedDB = NSSet(array: breedsDB)
            catDB.categoryDB = NSSet(array: categoriesDB)
        }
        CDAPI.publicher(save: action)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: {
                switch $0 {
                case true:
                    self.saved = true
                case false:
                    print("DB error")
                }
            }
            .store(in: &bag)
    }
    
    enum CatsDetailViewState {
        case loading, loaded(Cat), error(String)
    }
}

