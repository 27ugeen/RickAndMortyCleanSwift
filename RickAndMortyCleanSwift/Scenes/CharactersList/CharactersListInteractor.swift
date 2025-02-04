//
//  CharactersListInteractor.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

protocol CharactersListBusinessLogic {
    func fetchCharacters()
}

final class CharactersListInteractor: CharactersListBusinessLogic {
    var presenter: CharactersListPresentationLogic?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCharacters() {
        networkService.fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                CoreDataManager.shared.saveCharacters(characters)
                let response = CharactersListModels.Response(characters: characters)
                self?.presenter?.presentCharacters(response: response)
            case .failure:
                let cachedCharacters = CoreDataManager.shared.fetchCharacters()
                let response = CharactersListModels.Response(characters: cachedCharacters)
                self?.presenter?.presentCharacters(response: response)
            }
        }
    }
}
