//
//  MockNetworkManager.swift
//  ANFPracticeCoding
//
//  Created by karthik on 12/14/24.
//

import Combine
import Foundation

class MockNetworkManager: NetworkManagerProtocol {
    var mockData: Data?
    var mockError: Error?
    
    func fetchData(with request: URLRequest) -> AnyPublisher<Data, Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let data = mockData {
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}
