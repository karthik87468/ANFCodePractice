//
//  Untitled.swift
//  ANFPracticeCoding
//
//  Created by karthik on 12/14/24.
//
import SwiftUI
import Combine

// Model for JSON Data
struct PromoCard: Codable, Identifiable {
    let id = UUID() // Unique ID for SwiftUI List
    let backgroundImage: String?
    let topDescription: String?
    let title: String?
    let promoMessage: String?
    let bottomDescription: String?
    let content: [ContentItem]?
    
    struct ContentItem: Codable, Identifiable {
        let id = UUID()
        let title: String?
        let target: String?
    }
}


class PromoCardsViewModel: ObservableObject {
    @Published var promoCards: [PromoCard] = []
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func loadPromoCards() {
        // Create the URLRequest
        if let finalURL = URLParams().build() {
            var request = URLRequest(url: finalURL)
            request.httpMethod = "GET"
            
            networkManager.fetchData(with: request)
                .tryMap { data in
                    try JSONDecoder().decode([PromoCard].self, from: data)
                }
                .receive(on: DispatchQueue.main) // UI updates on main thread
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] promoCards in
                    self?.promoCards = promoCards
                })
                .store(in: &cancellables)

        }

    }
}
