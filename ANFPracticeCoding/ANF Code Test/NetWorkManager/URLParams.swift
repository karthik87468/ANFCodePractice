//
//  URLParams.swift
//  ANF Code Test
//
//  Created by karthik on 12/15/24.
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

    /// Get the final URL with parameters
    /// - Returns: The constructed URL
    func build() -> URL? {
        return urlComponents.url
    }
}
