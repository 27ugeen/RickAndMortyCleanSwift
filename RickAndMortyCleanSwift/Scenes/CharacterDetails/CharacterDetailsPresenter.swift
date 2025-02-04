//
//  CharacterDetailsPresenter.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

protocol CharacterDetailsPresentationLogic {
    func presentCharacterDetails(response: CharacterDetailsModels.Response)
}

final class CharacterDetailsPresenter: CharacterDetailsPresentationLogic {
    weak var viewController: CharacterDetailsDisplayLogic?

    func presentCharacterDetails(response: CharacterDetailsModels.Response) {
        let character = response.character
        let viewModel = CharacterDetailsModels.ViewModel(
            name: character.name,
            imageURL: character.imageURL,
            description: character.description
        )
        viewController?.displayCharacterDetails(viewModel: viewModel)
    }
}
