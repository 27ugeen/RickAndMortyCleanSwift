//
//  NetworkService.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchCharacters(nextPage: Bool, completion: @escaping (Result<[RMCharacter], NetworkService.NetworkError>) -> Void)
    func hasNextPage() -> Bool
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let session: URLSession
    private var nextPageURL: String?
    
    private var activeTask: URLSessionDataTask?
    
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
        case noInternet
    }
    
    func fetchCharacters(nextPage: Bool, completion: @escaping (Result<[RMCharacter], NetworkError>) -> Void) {
        let urlString = nextPage ? nextPageURL : baseURL + "/character"
        guard let url = URL(string: urlString ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url) { (result: Result<CharacterList, NetworkError>) in
            switch result {
            case .success(let characterList):
                self.nextPageURL = characterList.info.next
                completion(.success(characterList.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        activeTask?.cancel()
        activeTask = session.dataTask(with: url) { data, response, error in
            if let urlError = error as? URLError {
                guard urlError.code != .cancelled else { return }
                if urlError.code == .notConnectedToInternet {
                    completion(.failure(.noInternet))
                    return
                }
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        activeTask?.resume()
    }
    
    func hasNextPage() -> Bool {
        return nextPageURL != nil
    }
}
