//
//  CatsModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 11.04.2022.
//

import Foundation

struct Cat: Codable, Equatable {
    var uuid = UUID()
    let breeds: [Breed]
    let categories: [Category]?
    let id: String
    let url: String
    let width, height: Int
    
    enum CodingKeys: String, CodingKey {
        case breeds, categories
        case id, url, width, height
    }
}

extension Cat: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Cat, rhs: Cat) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

struct Breed: Codable, Equatable, Hashable {
    let id, name: String?
    let breedDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case breedDescription = "description"
    }
}

struct Category: Codable, Equatable, Hashable {
    let id: Int
    let name: String
}
