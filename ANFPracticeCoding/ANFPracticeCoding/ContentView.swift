//
//  ContentView.swift
//  ANFCodingPractice
//
//  Created by karthik on 12/14/24.
//

import SwiftUI



// Promo Card View
struct PromoCardView: View {
    let card: PromoCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Background Image
            AsyncImage(url: URL(string: card.backgroundImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            .clipped()
            
            VStack(spacing: 5) {
                // Text Fields
                Text(card.topDescription ?? "")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                Text(card.title ?? "")
                    .font(.system(size: 17, weight: .bold))
                
                Text(card.promoMessage ?? "")
                    .font(.system(size: 11))
                    .foregroundColor(.red)
                
                HTMLTextView(htmlContent: card.bottomDescription ?? "").padding()         .frame(maxWidth: 200)

            }.frame(maxWidth: .infinity, alignment: .center)

         
            if let content = card.content {
                ForEach(content.indices, id: \.self) { index in
                    let item = content[index]
                    getButton(item: item)
                }

            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
        .padding([.horizontal, .top])
    }
    
    @ViewBuilder
    func getButton(item: PromoCard.ContentItem) -> some View {
        Button(action: {
            print("button pressed")
            if let url = URL(string: item.target ?? "") {
                UIApplication.shared.open(url)
            }
        }) {
            VStack {
                Text(item.title ?? "No Title")
                    .foregroundColor(.black)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())

    }
}

// Main View
struct ContentView: View {
    @StateObject private var viewModel = PromoCardsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.promoCards.indices, id: \.self) { index in
                    let card = viewModel.promoCards[index]
                    PromoCardView(card: card).id(index)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .task {
                viewModel.loadPromoCards()
            }
        }
           
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String

    // Custom Coordinator to handle link taps
    class Coordinator: NSObject, UITextViewDelegate {
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            if var decodedURLString = URL.absoluteString.removingPercentEncoding
                {
                if let startRange = decodedURLString.range(of: "http"),
                   let endRange = decodedURLString.range(of: ".html") {
                    decodedURLString = String(decodedURLString[startRange.lowerBound...endRange.upperBound])
                    let decodedURL = NSURL(string: decodedURLString)
                    UIApplication.shared.open(decodedURL! as URL)
                }
                        
                
            }
            return false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator // Set the delegate
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let data = Data(htmlContent.utf8)
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            uiView.attributedText = attributedString
        } else {
            uiView.text = htmlContent
        }
    }
}
