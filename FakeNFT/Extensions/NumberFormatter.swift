//
//  NumberFormatter.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import Foundation

extension NumberFormatter {
    static let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
