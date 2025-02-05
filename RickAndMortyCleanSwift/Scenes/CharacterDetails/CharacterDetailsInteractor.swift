//
//  CharacterDetailsInteractor.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

protocol CharacterDetailsBusinessLogic {
    func fetchCharacterDetails(request: CharacterDetailsModels.Request)
}

final class CharacterDetailsInteractor: CharacterDetailsBusinessLogic {
    var presenter: CharacterDetailsPresentationLogic?

    func fetchCharacterDetails(request: CharacterDetailsModels.Request) {
        let response = CharacterDetailsModels.Response(
            id: request.id,
            name: request.name,
            imageURL: request.imageURL,
            description: request.description
        )
        presenter?.presentCharacterDetails(response: response)
    }
}
