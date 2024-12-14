//
//  URlParams.swift
//  ANFPracticeCoding
//
//  Created by karthik on 12/14/24.
//

import Foundation

struct Constants {
    struct API {
        static let baseURL = "https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.css"
    }
}


class URLParams {
    private var urlComponents: URLComponents


    init(baseURL: String = Constants.API.baseURL) {
        guard let components = URLComponents(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        self.urlComponents = components
    }

    /// Add a query parameter to the URL
    /// - Parameters:
    ///   - key: The name of the query parameter
    ///   - value: The value of the query parameter
    func addParam(key: String, value: String) {
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: key, value: value))
        urlComponents.queryItems = queryItems
    }

    /// Get the final URL with parameters
    /// - Returns: The constructed URL
    func build() -> URL? {
        return urlComponents.url
    }
}
