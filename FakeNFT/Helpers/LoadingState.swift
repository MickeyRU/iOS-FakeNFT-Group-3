import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded
    case error(Error)
}
