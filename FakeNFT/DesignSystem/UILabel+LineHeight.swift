//
//  UILabel+LineHeight.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 12.09.2023.
//

import UIKit

extension UILabel {
    var lineHeight: CGFloat {
        get { .zero }
        set {
            let lineHeight = newValue
            let mutableParagraphStyle = NSMutableParagraphStyle()
            mutableParagraphStyle.minimumLineHeight = lineHeight
            mutableParagraphStyle.maximumLineHeight = lineHeight

            self.attributedText = NSAttributedString(
                string: self.text ?? "",
                attributes: [.paragraphStyle: mutableParagraphStyle]
            )
        }
    }
}
