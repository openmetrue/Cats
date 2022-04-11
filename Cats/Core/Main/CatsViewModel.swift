//
//  CatsViewModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import Foundation
import Combine

final class CatsMainViewModel: ObservableObject {
    @Published var state: CatsMainViewState = .all
    @Published private(set) var cats: [Cat] = []
    @Published private(set) var breeds: [Breedes] = []
    @Published var searchText = ""
    @Published var page = 0
    let limit = 20
    private var bag = Set<AnyCancellable>()
    init() {
        setUpFetching()
    }
    private func setUpFetching() {
        $searchText
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
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
        case search, all, error(String)
    }
}

