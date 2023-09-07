//
//  StarsView.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 05.09.2023.
//

import UIKit

final class StarsView: UIView {
    
    enum Rating: Int {
        case zero = 0
        case one
        case two
        case three
        case four
        case five
    }
    
    var rating: Rating = .zero {
        didSet {
            self.setRating(self.rating)
        }
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let stars: [UIImageView] = {
        var stars: [UIImageView] = []

        for _ in 0..<5 {
            let starImage = UIImage(systemName: "star.fill")
            let starImageView = UIImageView(image: starImage)
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.tintColor = .unLightGray
            starImageView.contentMode = .scaleAspectFit
            stars.append(starImageView)
        }

        return stars
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Add subviews / Set constraints

extension StarsView {
    
    private func addSubviews() {
        addSubview(stackView)
        stars.forEach{ stackView.addViewWithNoTAMIC($0) }
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Set rating

private extension StarsView {
    func setRating(_ rating: Rating) {
        let rating = rating.rawValue
        
        stars.forEach { star in
            guard let indexOfStar = stars.firstIndex(of: star) else { return }
            star.tintColor = indexOfStar < rating ? .unYellow : .unLightGray
        }
    }
}
