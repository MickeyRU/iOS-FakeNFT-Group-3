import Foundation
import Kingfisher

protocol ImageValidatorServiceProtocol {
    func isValidImageURL(_ url: URL, completion: @escaping (Bool) -> Void)
}

final class ImageValidatorService: ImageValidatorServiceProtocol {
    func isValidImageURL(_ url: URL, completion: @escaping (Bool) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
