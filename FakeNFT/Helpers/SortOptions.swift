import Foundation

enum SortOption {
    case price
    case rating
    case title

    var description: String {
        switch self {
        case .price:
            return "По цене"
        case .rating:
            return "По рейтингу"
        case .title:
            return "По названию"
        }
    }
}
