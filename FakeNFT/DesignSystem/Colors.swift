import UIKit

extension UIColor {
    static let unGray = UIColor.init(hexString: "#625C5C")
    static let unRed = UIColor.init(hexString: "#F56B6C")
    static let unBackground = UIColor.init(hexString: "#1A1B2280")
    static let unGreen = UIColor.init(hexString: "#1C9F00")
    static let unBlue = UIColor.init(hexString: "#0A84FF")
    static let unBlack = UIColor.init(hexString: "#1A1B22")
    static let unWhite = UIColor.init(hexString: "#FFFFFF")
    static let unYellow = UIColor.init(hexString: "#FEEF0D")

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
