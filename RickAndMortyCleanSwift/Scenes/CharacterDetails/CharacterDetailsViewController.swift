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

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        interactor.fetchCharacterDetails(request: CharacterDetailsModels.Request(character: character))
    }

    private func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(imageView)
        view.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            imageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            detailsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func displayCharacterDetails(viewModel: CharacterDetailsModels.ViewModel) {
        nameLabel.text = viewModel.name
        detailsLabel.text = viewModel.description

        ImageLoader.shared.loadImage(from: viewModel.imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}
