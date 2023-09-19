import Foundation

enum SortOption {
    case price
    case rating
    case title

    var description: String {
        switch self {
        case .price:
            return NSLocalizedString("byPrice", comment: "")
        case .rating:
            return NSLocalizedString("byRating", comment: "")
        case .title:
            return NSLocalizedString("byName", comment: "")
        }
    }
}
