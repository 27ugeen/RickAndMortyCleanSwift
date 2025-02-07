//
//  CharactersListViewController.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

protocol CharactersListDisplayLogic: AnyObject {
    func displayCharacters(viewModel: CharactersListModels.ViewModel)
    func setLoadingState(isLoading: Bool)
}

final class CharactersListViewController: UIViewController, CharactersListDisplayLogic {
    private let interactor: CharactersListBusinessLogic
    private let router: CharactersListRoutingLogic
    
    private let listView = CharactersListView()
    private var characters: [CharactersListModels.CharacterViewModel] = []
    private var isFetchingMoreData = false

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
        interactor.fetchCharacters(nextPage: false)
    }
    
    private func setupTableView() {
        listView.tableView.dataSource = self
        listView.tableView.delegate = self
    }

    func displayCharacters(viewModel: CharactersListModels.ViewModel) {
        characters = viewModel.characters
        isFetchingMoreData = false
        DispatchQueue.main.async {
            self.setLoadingState(isLoading: false)
            self.listView.setFooterLoadingState(isLoading: false)
            self.listView.tableView.reloadData()
        }
    }
    
    func setLoadingState(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.listView.activityIndicator.startAnimating() : self.listView.activityIndicator.stopAnimating()
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
        let request = CharacterDetailsModels.Request(id: character.id, name: character.name, imageURL: character.imageURL, description: character.description)
        router.routeToDetails(for: request)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        guard position > scrollView.contentSize.height - scrollView.frame.size.height - 100 else { return }
        guard !isFetchingMoreData, NetworkMonitor.shared.isConnected, interactor.hasNextPage() else { return }

        isFetchingMoreData = true
        listView.setFooterLoadingState(isLoading: true)
        interactor.fetchCharacters(nextPage: true)
    }
}
