import XCTest
import Combine
@testable import ANF_Code_Test

class ANFExploreCardTableViewControllerTests: XCTestCase {

    var testInstance: ANFExploreCardTableViewController!
    private var viewModel: PromoCardsViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        mockNetworkManager = MockNetworkManager()
        let mockJSON = """
        [
            {
                "backgroundImage": "https://example.com/image1.jpg",
                "topDescription": "Top Description",
                "title": "Promo Card 1",
                "promoMessage": "Special Offer",
                "content": [
                    { "title": "Action 1", "target": "https://example.com/action1" }
                ]
            },
            {
                "backgroundImage": "https://example.com/image2.jpg",
                "topDescription": "Another Top Description",
                "title": "Promo Card 2",
                "promoMessage": "Limited Time Offer",
                "content": [
                    { "title": "Action 2", "target": "https://example.com/action2" }
                ]
            }
        ]
        """.data(using: .utf8)!
        mockNetworkManager.mockData = mockJSON
        viewModel = PromoCardsViewModel(networkManager: mockNetworkManager)
        
        if let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? ANFExploreCardTableViewController {
            viewController.viewModel = viewModel
            testInstance = viewController
        }
    }

    func test_numberOfSections_ShouldBeOne() {
        
        let numberOfSections = testInstance.tableView.numberOfSections
        XCTAssert(numberOfSections == 1, "table view should have 1 section")
    }
    
    func test_numberOfRows_ShouldBeTwo() {
        loadData()
        waitForExpectations(timeout: 2) { _ in
            let numberOfRows = self.testInstance.tableView.numberOfRows(inSection: 0)
            XCTAssert(numberOfRows == 2, "table view should have 2 cells based on mock data")
        }
    }
    
    func loadData() {
        let expectation = self.expectation(description: "Cell loaded")
        
        // Trigger loading the promo cards
        viewModel.loadPromoCards()
        
        // Set up a listener to wait for data to load
        var cancellable: AnyCancellable?
        cancellable = viewModel.$promoCards
            .sink { [weak self] cards in
                guard let _ = self else { return }
                if !cards.isEmpty {
                    expectation.fulfill() // Fulfill only once
                    cancellable?.cancel() // Cancel the subscription
                }
            }
    }
    
    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        loadData()
        waitForExpectations(timeout: 2) { _ in
            if let firstCell = self.testInstance.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ExploreContentCell {
                XCTAssert(firstCell.backgroundImageView != nil, "image not be nil")
            }
        }
    }

    
    func test_viewModelLoadPromoCards() {
        loadData()
        
        waitForExpectations(timeout: 2) { _ in
            XCTAssert(self.viewModel.promoCards.count > 0, "Promo cards should be loaded")
        }
    }
}
