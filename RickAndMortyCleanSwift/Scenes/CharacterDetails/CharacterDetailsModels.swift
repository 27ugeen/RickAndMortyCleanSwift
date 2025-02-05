//
//  CharacterDetailsModels.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

enum CharacterDetailsModels {
    struct Request {
        let character: CharactersListModels.CharacterViewModel
    }

    struct Response {
        let character: CharactersListModels.CharacterViewModel
    }

    struct ViewModel {
        let id: Int
        let name: String
        let imageURL: String
        let description: String
    }
}
