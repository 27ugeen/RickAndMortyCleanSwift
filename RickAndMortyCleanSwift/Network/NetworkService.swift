//
//  NetworkService.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

final class NetworkService {
    private let baseURL = "https://rickandmortyapi.com/api"
    
    enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case decodingFailed
    }
    
    func fetchCharacters(completion: @escaping (Result<[RMCharacter], NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/character") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(CharacterList.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}
