//
//  CharacterDetailsFactory.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

protocol CharacterDetailsFactoryProtocol {
    func createCharacterDetailsModule(request: CharacterDetailsModels.Request) -> UIViewController
}

final class CharacterDetailsFactory: CharacterDetailsFactoryProtocol {
    func createCharacterDetailsModule(request: CharacterDetailsModels.Request) -> UIViewController {
        let interactor = CharacterDetailsInteractor()
        let presenter = CharacterDetailsPresenter()
        let router = CharacterDetailsRouter()
        let detailsVC = CharacterDetailsViewController(interactor: interactor, router: router, characterRequest: request)

        interactor.presenter = presenter
        presenter.viewController = detailsVC
        router.viewController = detailsVC

        return detailsVC
    }
}
