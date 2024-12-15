//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit
import Combine

class ANFExploreCardTableViewController: UITableViewController {
    var promoCards: [PromoCardsViewModel.PromoCard] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var viewModel = PromoCardsViewModel()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: PromoCardsViewModel = PromoCardsViewModel())  {
        super.init(style: .plain)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ExploreContentCell.self, forCellReuseIdentifier: "ExploreContentCell")
        viewModel.loadPromoCards()
        viewModel.$promoCards.sink { [weak self] cards in
            self?.promoCards = cards
        }.store(in: &cancellables)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        promoCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExploreContentCell", for: indexPath) as? ExploreContentCell else {
            return  UITableViewCell()
        }
        cell.model = promoCards[indexPath.row]
        viewModel.loadImage(imageURL: cell.model?.backgroundImage ?? "") { image in
            cell.backgroundImageView.image = image
        }
        return cell
    }
}
