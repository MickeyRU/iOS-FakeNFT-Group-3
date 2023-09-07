//
//  AppButton.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 05.09.2023.
//

import UIKit

final class AppButton: UIButton {
    
    enum ButtonType {
        case filled
        case bordered
        case nftCartRemove
        case nftCartCancel
    }
    
    private let type: ButtonType
    private let title: String
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1

        static var filledTypeFont: UIFont { UIFont.sfBold17 }
        static var borderedTypeFont: UIFont { UIFont.sfRegular15 }
        static var nftCartTypeFont: UIFont { UIFont.sfRegular17 }
    }
    
    init(type: ButtonType, title: String) {
        self.type = type
        self.title = title
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppButton {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true

        switch self.type {
        case .filled:
            self.setFilledType()
        case .bordered:
            self.setBorderedType()
        case .nftCartRemove, .nftCartCancel:
            self.setNftCartButton(type: self.type)
        }
    }

    func setFilledType() {
        backgroundColor = .unBlack

        let font = Constants.filledTypeFont
        let textColor = UIColor.unWhite
        let titleAttributes = [NSAttributedString.Key.font: font,
                               NSAttributedString.Key.foregroundColor: textColor]
        let title = NSAttributedString(string: self.title, attributes: titleAttributes)
        self.setAttributedTitle(title, for: .normal)
    }

    func setBorderedType() {
        let color = UIColor.unBlack

        backgroundColor = .clear
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = color.cgColor

        let font = Constants.borderedTypeFont
        let title = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.font: font,
                                                                        NSAttributedString.Key.foregroundColor: color])
        self.setAttributedTitle(title, for: .normal)
    }

    func setNftCartButton(type: ButtonType) {
        backgroundColor = .unBlack

        let font = Constants.nftCartTypeFont
        let color = self.getColorForNftCartButton(type: type)

        let title = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.font: font,
                                                                        NSAttributedString.Key.foregroundColor: color])
        self.setAttributedTitle(title, for: .normal)
    }
}

extension AppButton {
    func getColorForNftCartButton(type: ButtonType) -> UIColor {
        switch type {
        case .nftCartCancel:
            return .unWhite
        case .nftCartRemove:
            return .unRed
        default:
            return .unWhite
        }
    }
}
