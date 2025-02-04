//
//  CharacterDetailsViewController.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

protocol CharacterDetailsDisplayLogic: AnyObject {
    func displayCharacterDetails(viewModel: CharacterDetailsModels.ViewModel)
}

final class CharacterDetailsViewController: UIViewController, CharacterDetailsDisplayLogic {
    private let interactor: CharacterDetailsBusinessLogic
    private let router: CharacterDetailsRoutingLogic
    private let character: CharactersListModels.CharacterViewModel
    
    private let detailsView = CharacterDetailsView()
    
    init(interactor: CharacterDetailsBusinessLogic,
         router: CharacterDetailsRoutingLogic,
         character: CharactersListModels.CharacterViewModel) {
        self.interactor = interactor
        self.router = router
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        interactor.fetchCharacterDetails(request: CharacterDetailsModels.Request(character: character))
    }

    func displayCharacterDetails(viewModel: CharacterDetailsModels.ViewModel) {
        detailsView.configure(with: viewModel)
    }
}
