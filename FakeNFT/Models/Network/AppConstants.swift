//
//  AppConstants.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 10.09.2023.
//

import Foundation

struct AppConstants {
    
    enum Api {
        static let version = "/api/v1"
        static let defaultEndpoint = "https://64e794b8b0fd9648b7902489.mockapi.io"
        
        enum Cart {
            static let controller = "orders"
            static let paymentController = "payment"
        }
        
        enum Nft {
            static let controller = "nft"
        }
        
        enum Currencies {
            static let controller = "currencies"
        }
    }
    
    enum Links {
        static let purchaseUserAgreement = "https://yandex.ru/legal/practicum_termsofuse/"
    }
}
