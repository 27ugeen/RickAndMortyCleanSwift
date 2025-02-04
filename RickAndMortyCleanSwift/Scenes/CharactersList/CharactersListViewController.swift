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
    private let interactor: CharactersListBusinessLogic
    private let router: CharactersListRoutingLogic
    private var characters: [CharactersListModels.CharacterViewModel] = []
    
    private let listView = CharactersListView()

    init(interactor: CharactersListBusinessLogic, router: CharactersListRoutingLogic) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }

    override func loadView() {
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        interactor.fetchCharacters()
    }
    
    private func setupTableView() {
        listView.tableView.dataSource = self
        listView.tableView.delegate = self
    }

    func displayCharacters(viewModel: CharactersListModels.ViewModel) {
        characters = viewModel.characters
        DispatchQueue.main.async {
            self.listView.tableView.reloadData()
        }
    }
}

extension CharactersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        let character = characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        router.routeToDetails(for: character)
    }
}
