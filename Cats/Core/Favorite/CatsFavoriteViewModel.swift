//
//  CatsFavoriteViewModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import SwiftUI
import CoreData
import Combine

final class CatsFavoriteViewModel: ObservableObject {
    @Published var state: CatsFavoriteViewState = .loading
    let coreDataStore = CoreDataStore.shared
    private var bag = Set<AnyCancellable>()
    
    public func fetchCats() {
        let request = NSFetchRequest<CatDB>(entityName: "CatDB")
        coreDataStore
            .publicher(fetch: request)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    if error.code == 0 {
                        self.state = .empty
                    } else {
                        self.state = .error(error.localizedDescription)
                    }
                }
            } receiveValue: {
                self.state = $0.isEmpty ? .empty : .loaded($0)
            }
            .store(in: &bag)
    }
    public func deleteAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatDB")
        coreDataStore
            .publicher(delete: request)
            .sink {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { _ in
                print("All deleted")
            }
            .store(in: &bag)
        fetchCats()
    }
    enum CatsFavoriteViewState {
        case empty, loading, loaded([CatDB]), error(String)
    }
}
