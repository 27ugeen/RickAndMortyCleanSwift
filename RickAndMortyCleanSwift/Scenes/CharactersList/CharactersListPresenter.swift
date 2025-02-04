//
//  CharactersListPresenter.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

protocol CharactersListPresentationLogic {
    func presentCharacters(response: CharactersListModels.Response)
}

final class CharactersListPresenter: CharactersListPresentationLogic {
    weak var viewController: CharactersListDisplayLogic?

    func presentCharacters(response: CharactersListModels.Response) {
        let viewModels = response.characters.map {
            CharactersListModels.CharacterViewModel(
                id: $0.id,
                name: $0.name,
                imageURL: $0.image
            )
        }
        let viewModel = CharactersListModels.ViewModel(characters: viewModels)
        viewController?.displayCharacters(viewModel: viewModel)
    }
}
