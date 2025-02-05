//
//  CharactersListModels.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

struct CharacterList: Decodable {
    let info: PageInfo
    let results: [RMCharacter]
}

struct PageInfo: Decodable {
    let next: String?
}

struct RMCharacter: Decodable {
    let id: Int
    let name: String
    let image: String
    let status: String
    let species: String
}

enum CharactersListModels {
    struct Response {
        let characters: [RMCharacter]
    }
    
    struct ViewModel {
        let characters: [CharacterViewModel]
    }
    
    struct CharacterViewModel {
        let id: Int
        let name: String
        let imageURL: String
        let description: String
    }
}
