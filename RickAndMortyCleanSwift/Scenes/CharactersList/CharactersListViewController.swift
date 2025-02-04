//
//  CharactersListViewController.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

protocol CharactersListDisplayLogic: AnyObject {
    func displayCharacters(viewModel: CharactersListModels.ViewModel)
}

final class CharactersListViewController: UIViewController, CharactersListDisplayLogic {
    var interactor: CharactersListBusinessLogic?
    private var characters: [CharactersListModels.CharacterViewModel] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.fetchCharacters()
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
    }

    func displayCharacters(viewModel: CharactersListModels.ViewModel) {
        characters = viewModel.characters
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension CharactersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        let character = characters[indexPath.row]
        cell.textLabel?.text = character.name
        // TODO: Додати завантаження зображення
        return cell
    }
}
