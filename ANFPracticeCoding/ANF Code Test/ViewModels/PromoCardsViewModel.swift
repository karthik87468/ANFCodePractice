//
//  PromoCardsViewModel.swift
//  ANF Code Test
//
//  Created by karthik on 12/15/24.
//

import UIKit
import Combine

class PromoCardsViewModel: ObservableObject {
    @Published var promoCards: [PromoCard] = []
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func loadPromoCards() {
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
                    if let self {
                        self.promoCards = promoCards
                    }
                })
                .store(in: &cancellables)
        }

    }
    
    func loadImage(imageURL: String, completionHandler: @escaping (UIImage?) -> Void) {
        if let cachedImage = ImageCache.shared.retrieveImage(forKey: imageURL) {
            completionHandler(cachedImage)
            return
        }
        
        guard let url = URL(string: imageURL) else {
            completionHandler(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if self == nil { return }
            
            if let data = data, let image = UIImage(data: data) {
                ImageCache.shared.storeImage(image, forKey: imageURL)
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
        
        task.resume()
    }

}

extension PromoCardsViewModel {
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

}
