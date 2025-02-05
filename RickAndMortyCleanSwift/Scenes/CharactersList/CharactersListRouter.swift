//
//  CharactersListRouter.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

protocol CharactersListRoutingLogic {
    func routeToDetails(for request: CharacterDetailsModels.Request)
}

final class CharactersListRouter: CharactersListRoutingLogic {
    weak var viewController: UIViewController?
    private let detailsFactory: CharacterDetailsFactoryProtocol

    init(detailsFactory: CharacterDetailsFactoryProtocol) {
        self.detailsFactory = detailsFactory
    }

    func routeToDetails(for request: CharacterDetailsModels.Request) {
        let detailsVC = detailsFactory.createCharacterDetailsModule(request: request)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
