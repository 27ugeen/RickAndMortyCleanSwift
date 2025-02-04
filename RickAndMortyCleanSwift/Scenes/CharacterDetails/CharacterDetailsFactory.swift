//
//  CharacterDetailsFactory.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

protocol CharacterDetailsFactoryProtocol {
    func createCharacterDetailsModule(character: CharactersListModels.CharacterViewModel) -> UIViewController
}

final class CharacterDetailsFactory: CharacterDetailsFactoryProtocol {
    func createCharacterDetailsModule(character: CharactersListModels.CharacterViewModel) -> UIViewController {
        let interactor = CharacterDetailsInteractor()
        let presenter = CharacterDetailsPresenter()
        let router = CharacterDetailsRouter()
        let detailsVC = CharacterDetailsViewController(interactor: interactor, router: router, character: character)

        interactor.presenter = presenter
        presenter.viewController = detailsVC
        router.viewController = detailsVC

        return detailsVC
    }
}
