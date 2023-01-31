//
//  NetworkManager.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 31/01/23.
//

import Foundation

class NetworkManager {
    func fetchMovieDataFromAPI<T: Codable>(url: String, expecting: T.Type ,completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }

            guard let data = data else { return }

            do {
                let decodedData = try JSONDecoder().decode(expecting, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
