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
        let response = CharacterDetailsModels.Response(character: request.character)
        presenter?.presentCharacterDetails(response: response)
    }
}
