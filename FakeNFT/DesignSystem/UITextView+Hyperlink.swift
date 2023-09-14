//
//  UITextView+Hyperlink.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 12.09.2023.
//

import UIKit

extension UITextView {
    func addHyperLinksToText(originalText: String, hyperLinks: [String: String], lineHeight: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = lineHeight
        let attributedOriginalText = NSMutableAttributedString(string: originalText)

        let font = UIFont.sfRegular13
        let fullTextColor = UIColor.unBlack

        for (hyperLink, urlString) in hyperLinks {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
            let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
            attributedOriginalText.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: fullTextColor,
                range: fullRange
            )
        }

        let linkTextColor = UIColor.unBlue
        self.linkTextAttributes = [NSAttributedString.Key.foregroundColor: linkTextColor]
        self.attributedText = attributedOriginalText
    }
}
