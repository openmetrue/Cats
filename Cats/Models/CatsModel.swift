//
//  CatsModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 11.04.2022.
//

import Foundation

struct Cat: Codable, Equatable {
    let breeds: [Breed]
    let categories: [Category]?
    let id: String
    let url: String
    let width, height: Int
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
