//
//  CatsViewModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import Foundation
import Combine

final class CatsMainViewModel: ObservableObject {
    @Published private(set) var state: CatsMainViewState = .loading
    @Published private(set) var cats: [Cat] = []
    @Published private(set) var breeds: [Breedes] = []
    @Published var searchText = ""
    public let restOfCellsBeforeFetch = 10
    private let limit = 40
    private var page = 0
    public let loadMoreSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    init() {
        setUpFetching()
    }
    private func setUpFetching() {
        $searchText
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.isEmpty {
                    self.state = .all
                    return nil
                }
                self.state = .search
                return string
            })
            .compactMap { $0 }
            .sink(receiveValue: { [self] (searchText) in
                getCatsSearch(searchText)
            }).store(in: &bag)
    }
    public func getCatsSearch(_ searchText: String) {
        API.searchCats(searchText).sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                }
            }, receiveValue: {
                self.breeds = $0
            }).store(in: &bag)
    }
    public func fetchNextPageIfPossible() {
        API.getAllCats(page: page, limit: limit).sink(receiveCompletion: {
            switch $0 {
            case .finished:
                break
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }, receiveValue: {
            self.cats += $0
            self.page += 1
        }).store(in: &bag)
    }
    enum CatsMainViewState {
        case loading, search, all, error(String)
    }
}

