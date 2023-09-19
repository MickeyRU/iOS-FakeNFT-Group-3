//
//  PurchaseBackgroundView.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 05.09.2023.
//

import UIKit

class PurchaseBackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .unLightGray
        layer.masksToBounds = true
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
