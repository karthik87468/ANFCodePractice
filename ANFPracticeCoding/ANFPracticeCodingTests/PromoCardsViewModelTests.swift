//
//  PromoCardsViewModelTests.swift
//  ANFPracticeCoding
//
//  Created by karthik on 12/14/24.
//

import XCTest
import Combine
@testable import ANFPracticeCoding

final class PromoCardsViewModelTests: XCTestCase {
    private var viewModel: PromoCardsViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = PromoCardsViewModel(networkManager: mockNetworkManager)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadPromoCards_Success() {
        // Mock JSON Data
        let mockJSON = """
        [
            {
                "backgroundImage": "https://example.com/image1.jpg",
                "topDescription": "Top Description",
                "title": "Promo Card 1",
                "promoMessage": "Special Offer",
                "bottomDescription": "Bottom Description",
                "content": [
                    { "title": "Action 1", "target": "https://example.com/action1" }
                ]
            },
            {
                "backgroundImage": "https://example.com/image2.jpg",
                "topDescription": "Another Top Description",
                "title": "Promo Card 2",
                "promoMessage": "Limited Time Offer",
                "bottomDescription": "Another Bottom Description",
                "content": [
                    { "title": "Action 2", "target": "https://example.com/action2" }
                ]
            }
        ]
        """.data(using: .utf8)!
        
        mockNetworkManager.mockData = mockJSON
        
        let expectation = self.expectation(description: "Load Promo Cards")
        
        viewModel.$promoCards
            .dropFirst()
            .sink { promoCards in
                XCTAssertEqual(promoCards.count, 2, "Expected two promo cards")
                XCTAssertEqual(promoCards.first?.title, "Promo Card 1", "First promo card title mismatch")
                XCTAssertEqual(promoCards.first?.content?.first?.title, "Action 1", "First content item title mismatch")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger the API call
        viewModel.loadPromoCards()
        
        // Wait for the expectation
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadPromoCards_Failure() {
        mockNetworkManager.mockError = URLError(.notConnectedToInternet)
        
        let expectation = self.expectation(description: "Handle Error Gracefully")
        expectation.isInverted = true
        
        viewModel.$promoCards
            .dropFirst()
            .sink { promoCards in
                XCTFail("promoCards should not change when an error occurs")
            }
            .store(in: &cancellables)
        
        viewModel.loadPromoCards()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
