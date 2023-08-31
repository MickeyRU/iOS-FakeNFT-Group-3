//
//  CartPlaceholderView.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 30.08.2023.
//

import UIKit

final class CartPlaceholderView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "cart_placeholder_text".localized
        label.font = .sfBold17
        label.textColor = .unBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        addConstraints()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .unWhite
    }
    
    private func addSubviews() {
        addSubview(label)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
