//
//  BreedesModel.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 11.04.2022.
//

import Foundation

struct Breedes: Codable, Identifiable {
    let id, name: String
    let countryCode: String?
    let referenceImageID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case countryCode = "country_code"
        case referenceImageID = "reference_image_id"
    }
}

