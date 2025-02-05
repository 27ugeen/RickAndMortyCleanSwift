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

    private let detailsView = CharacterDetailsView()
    private let characterRequest: CharacterDetailsModels.Request

    init(interactor: CharacterDetailsBusinessLogic,
         router: CharacterDetailsRoutingLogic,
         characterRequest: CharacterDetailsModels.Request) {
        self.interactor = interactor
        self.router = router
        self.characterRequest = characterRequest
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
        interactor.fetchCharacterDetails(request: characterRequest)
    }

    func displayCharacterDetails(viewModel: CharacterDetailsModels.ViewModel) {
        detailsView.configure(with: viewModel)
    }
}
