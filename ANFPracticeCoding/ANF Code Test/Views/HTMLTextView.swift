//
//  HTMLTextView.swift
//  ANF Code Test
//
//  Created by karthik on 12/15/24.
//

import UIKit

class HTMLTextView: UIView, UITextViewDelegate {
    
    let textView = UITextView()
    var htmlContent: String? {
        didSet {
            updateTextViewContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }
    
    private func setupTextView() {
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clear
        textView.delegate = self 
        addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func updateTextViewContent() {
        guard let htmlContent = htmlContent else { return }
        
        let data = Data(htmlContent.utf8)
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            textView.attributedText = attributedString
        } else {
            textView.text = htmlContent
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if var decodedURLString = URL.absoluteString.removingPercentEncoding {
            if let startRange = decodedURLString.range(of: "http"),
               let endRange = decodedURLString.range(of: ".html") {
                decodedURLString = String(decodedURLString[startRange.lowerBound...endRange.upperBound])
                let url = NSURL(string: decodedURLString)
                if let url {
                    UIApplication.shared.open(url as URL)
                }
            }
        }
        return false
    }

}
