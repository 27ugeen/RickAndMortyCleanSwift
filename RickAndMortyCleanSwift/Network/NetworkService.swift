//
//  NetworkService.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchCharacters(completion: @escaping (Result<[RMCharacter], NetworkService.NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let session: URLSession

    init(baseURL: String = APIConstants.baseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case decodingFailed
        case invalidResponse
        case statusCode(Int)
    }
    
    func fetchCharacters(completion: @escaping (Result<[RMCharacter], NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/character") else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url) { (result: Result<CharacterList, NetworkError>) in
            switch result {
            case .success(let characterList):
                completion(.success(characterList.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ Network Error:", error.localizedDescription)
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.statusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("❌ Decoding Error:", error)
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}
