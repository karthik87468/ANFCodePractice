//
//  ExploreContentCell.swift
//  ANF Code Test
//
//  Created by karthik on 12/15/24.
//
import UIKit

class ExploreContentCell: UITableViewCell {
    
    var model:  PromoCardsViewModel.PromoCard? {
        didSet {
            applymodel()
        }
    }
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()

    private let topDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    private let promoMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .red
        label.contentMode = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottomDescriptionView: HTMLTextView = {
        let label = HTMLTextView()
        label.textView.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applymodel() {
        if let model = model {
            configure(with: model)
        }
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        [backgroundImageView, topDescriptionLabel, titleLabel, promoMessageLabel, bottomDescriptionView, buttonStackView].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 200),

            topDescriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            topDescriptionLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 8),

            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topDescriptionLabel.bottomAnchor, constant: 5),
           
            promoMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            promoMessageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            bottomDescriptionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            bottomDescriptionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            bottomDescriptionView.topAnchor.constraint(equalTo: promoMessageLabel.bottomAnchor, constant: 5),

            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStackView.topAnchor.constraint(equalTo: bottomDescriptionView.bottomAnchor, constant: 8),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration

    func configure(with card: PromoCardsViewModel.PromoCard) {

        topDescriptionLabel.text = card.topDescription
        titleLabel.text = card.title
        promoMessageLabel.text = card.promoMessage
        bottomDescriptionView.htmlContent = card.bottomDescription
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let content = card.content {
            for item in content {
                let button = createButton(for: item)
                buttonStackView.addArrangedSubview(button)
            }
        }
    }

    private func createButton(for item: PromoCardsViewModel.PromoCard.ContentItem) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(item.title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.contentMode = .center
        button.layer.cornerRadius = 4
        button.contentHorizontalAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.tag = item.id.hashValue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc private func buttonTapped(_ sender: UIButton) {
       let cardContent = model?.content?.first(where: { $0.id.hashValue == sender.tag })
       if let urlString = cardContent?.target {
           guard let url = URL(string: urlString) else { return }
           UIApplication.shared.open(url)
        }
       
    }
}

extension ExploreContentCell {
    var testooks: TestHooks {
        TestHooks(target: self)
    }
    struct TestHooks {
        let target: ExploreContentCell
        init(target: ExploreContentCell) {
            self.target = target
        }
        
        var topDescriptionLabel: UILabel {
            target.topDescriptionLabel
        }
    }
    
    
}
