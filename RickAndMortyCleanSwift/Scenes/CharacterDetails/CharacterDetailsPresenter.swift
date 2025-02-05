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
        let viewModel = CharacterDetailsModels.ViewModel(
            id: response.id,
            name: response.name,
            imageURL: response.imageURL,
            description: response.description
        )
        viewController?.displayCharacterDetails(viewModel: viewModel)
    }
}
