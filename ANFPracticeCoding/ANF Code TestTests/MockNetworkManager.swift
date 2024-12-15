//
//  MockNetworkManager.swift
//  ANF Code Test
//
//  Created by karthik on 12/15/24.
//

import Combine
import Foundation
@testable import ANF_Code_Test
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
