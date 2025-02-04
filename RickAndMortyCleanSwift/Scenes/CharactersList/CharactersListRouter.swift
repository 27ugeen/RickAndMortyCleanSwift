//
//  CharactersListRouter.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

protocol CharactersListRoutingLogic {
    func routeToDetails(for character: CharactersListModels.CharacterViewModel)
}

final class CharactersListRouter: CharactersListRoutingLogic {
    weak var viewController: UIViewController?
    private let detailsFactory: CharacterDetailsFactoryProtocol

    init(detailsFactory: CharacterDetailsFactoryProtocol) {
        self.detailsFactory = detailsFactory
    }

    func routeToDetails(for character: CharactersListModels.CharacterViewModel) {
        let detailsVC = detailsFactory.createCharacterDetailsModule(character: character)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
