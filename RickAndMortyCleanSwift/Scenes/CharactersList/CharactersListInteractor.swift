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
    private let networkService = NetworkService()
    
    func fetchCharacters() {
        networkService.fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                let response = CharactersListModels.Response(characters: characters)
                self?.presenter?.presentCharacters(response: response)
            case .failure:
                // Обробка помилки
                break
            }
        }
    }
}
