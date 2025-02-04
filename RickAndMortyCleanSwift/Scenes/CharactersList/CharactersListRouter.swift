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

    func routeToDetails(for character: CharactersListModels.CharacterViewModel) {
        let detailsVC = CharacterDetailsViewController()
        detailsVC.character = character
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
