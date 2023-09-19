import UIKit

extension UIColor {
    static let unGray = UIColor.init(hexString: "#625C5C")
    static let unRed = UIColor.init(hexString: "#F56B6C")
    static let unBackground = UIColor.init(hexString: "#1A1B2280")
    static let unGreen = UIColor.init(hexString: "#1C9F00")
    static let unBlue = UIColor.init(hexString: "#0A84FF")
    static let unYellow = UIColor.init(hexString: "#FEEF0D")
    static let unGreenUniversal = UIColor.init(hexString: "#1C9F00")
    static let unBlackOnly = UIColor.init(hexString: "#1A1B22")
    
    static let unBlack = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.init(hexString: "#1A1B22")
        } else {
            return UIColor.init(hexString: "FFFFFF")
        }
    }
    
    static let unWhite = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.init(hexString: "#FFFFFF")
        } else {
            return UIColor.init(hexString: "1A1B22")
        }
    }
    
    static let unLightGray = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.init(hexString: "#F7F7F8")
        } else {
            return UIColor.init(hexString: "2C2C2E")
        }
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
}
