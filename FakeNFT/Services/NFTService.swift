import Foundation

final class NFTService {
    static let shared = NFTService(networkClient: DefaultNetworkClient())
    private let networkClient: NetworkClient
    
    private var currentTasks: [NetworkTask] = []
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchNFT(nftID: String, completion: @escaping (Result<NFT, Error>) -> Void) {
        let request = FetchNFTNetworkRequest(nftID: nftID)
        fetchData(request: request, type: NFT.self, retryCount: 0, delayInterval: 3.0, completion: completion)
    }
    
    func fetchAuthor(authorID: String, completion: @escaping (Result<Author, Error>) -> Void) {
        let request = FetchAuthorNetworkRequest(authorID: authorID)
        fetchData(request: request, type: Author.self, retryCount: 0, delayInterval: 3.0, completion: completion)
    }
    
    func stopAllTasks() {
        currentTasks.forEach { $0.cancel() }
        currentTasks.removeAll()
    }
    
    private func fetchData<T: Decodable>(request: NetworkRequest, type: T.Type, retryCount: Int, delayInterval: Double, completion: @escaping (Result<T, Error>) -> Void) {
        let task = networkClient.send(request: request, type: T.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if retryCount < 3 {
                    if case NetworkClientError.httpStatusCode(429) = error {
                        let newRetryCount = retryCount + 1
                        let newDelayInterval = delayInterval * 2
                        DispatchQueue.global().asyncAfter(deadline: .now() + delayInterval) {
                            self.fetchData(request: request, type: T.self, retryCount: newRetryCount, delayInterval: newDelayInterval, completion: completion)
                        }
                    } else {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
        guard let task = task else {
            print("task error")
            return
        }
        self.currentTasks.append(task)
    }
}
