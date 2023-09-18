//
//  Double.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import Foundation

extension Double {
    var nftCurrencyFormatted: String {
        let formatter = NumberFormatter.doubleFormatter
        let string = formatter.string(from: self as NSNumber)
        return string ?? ""
    }
}
