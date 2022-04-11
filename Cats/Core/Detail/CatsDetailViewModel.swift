//
//  CatsDetailViewModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import Foundation
import Combine

final class CatsDetailViewModel: ObservableObject {
    @Published var state: CatsDetailViewState = .loading
    let coreDataStore = CoreDataStore.shared
    private var bag = Set<AnyCancellable>()
    public init(cat: Cat) {
        self.state = .loaded(cat)
    }
    public init(breed: Breedes) {
        self.loadCat(id: breed.referenceImageID ?? "hBXicehMA")
    }
    
    public func loadCat(id: String) {
        API.getCatsFromID(id).sink(receiveCompletion: {
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
        let action: (()->()) = {
            let catDB: CatDB = self.coreDataStore.createEntity()
            catDB.id = cat.id
            catDB.url = cat.url
            catDB.width = Int64(cat.width)
            catDB.height = Int64(cat.height)
    
            var breedsDB: [BreedDB] = []
            for breed in cat.breeds {
                let breedDB: BreedDB = self.coreDataStore.createEntity()
                breedDB.id = breed.id
                breedDB.name = breed.name
                breedDB.breedDescription = breed.breedDescription
                breedsDB.append(breedDB)
            }
            
            var categoriesDB: [CategoryDB] = []
            if let categories = cat.categories {
                for category in categories {
                    let categoryDB: CategoryDB = self.coreDataStore.createEntity()
                    categoryDB.id = Int64(category.id)
                    categoryDB.name = category.name
                    categoriesDB.append(categoryDB)
                }
            }
            
            catDB.breedDB = NSSet(array: breedsDB)
            catDB.categoryDB = NSSet(array: categoriesDB)
        }
        coreDataStore
            .publicher(save: action)
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
                    break
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

