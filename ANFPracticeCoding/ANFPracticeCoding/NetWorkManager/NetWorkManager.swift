//
//  NetWorkManager.swift
//  ANFPracticeCoding
//
//  Created by karthik on 12/14/24.
//

import Foundation
import Combine


protocol NetworkManagerProtocol {
    /// Fetch data using a URLRequest
    /// - Parameter request: The URLRequest to execute
    /// - Returns: A publisher that emits data or an error
    func fetchData(with request: URLRequest) -> AnyPublisher<Data, Error>
}


import Foundation
import Combine

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager() 
    private init() {}

    func fetchData(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return result.data
            }
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .eraseToAnyPublisher()
    }
}

enum NetworkError: LocalizedError {
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server response was invalid."
        }
    }
}
