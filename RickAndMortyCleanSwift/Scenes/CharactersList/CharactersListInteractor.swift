//
//  CharactersListInteractor.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

protocol CharactersListBusinessLogic {
    func fetchCharacters(nextPage: Bool)
    func hasNextPage() -> Bool
}

final class CharactersListInteractor: CharactersListBusinessLogic {
    var presenter: CharactersListPresentationLogic?
    private let networkService: NetworkServiceProtocol
    private var allCharacters: [RMCharacter] = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCharacters(nextPage: Bool) {
        networkService.fetchCharacters(nextPage: nextPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let characters):
                self.allCharacters.append(contentsOf: characters)
                CoreDataManager.shared.saveCharacters(self.allCharacters)
                self.presenter?.presentCharacters(
                    response: CharactersListModels.Response(characters: self.allCharacters)
                )
            case .failure(let error):
                switch error {
                case .noInternet:
                    let cachedCharacters = CoreDataManager.shared.fetchCharacters()
                    self.allCharacters = cachedCharacters
                    self.presenter?.presentCharacters(
                        response: CharactersListModels.Response(characters: cachedCharacters)
                    )
                default:
                    print("Network Error:", error)
                }
            }
        }
    }
    
    func hasNextPage() -> Bool {
        return networkService.hasNextPage()
    }
}
