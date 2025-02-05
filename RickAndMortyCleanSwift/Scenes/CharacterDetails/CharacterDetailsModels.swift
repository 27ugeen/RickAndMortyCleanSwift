//
//  CharacterDetailsModels.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

enum CharacterDetailsModels {
    struct Request {
        let id: Int
        let name: String
        let imageURL: String
        let description: String
    }

    struct Response {
        let id: Int
        let name: String
        let imageURL: String
        let description: String
    }

    struct ViewModel {
        let id: Int
        let name: String
        let imageURL: String
        let description: String
    }
}
