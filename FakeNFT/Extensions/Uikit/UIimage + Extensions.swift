//
//  UIimage + Extensions.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 31.08.2023.
//

import UIKit

extension UIImage {
    
    enum PaymentResult {
        static let success = UIImage.named("CartPaymentSuccess")
        static let failure = UIImage.named("CartPaymentFailure")
        static let active = UIImage.named("CartActive")
        static let nonActive = UIImage.named("CartNonActive")
    }
    
    enum Currencies {
        static let apeCoin = UIImage.named("Apecoin")
        static let bitcoin = UIImage.named("Bitcoin")
        static let cardano = UIImage.named("Cardano")
        static let dogecoin = UIImage.named("Dogecoin")
        static let etherium = UIImage.named("Ethereum")
        static let shibaInu = UIImage.named("ShibaInu")
        static let solana = UIImage.named("Solana")
        static let tether = UIImage.named("Tether")
    }
}

extension UIImage {
    static func named(_ named: String) -> UIImage {
        guard let image = UIImage(named: named) else {
            assertionFailure("Image not loading: \(named)")
            return UIImage()
        }
        return image
    }
}
