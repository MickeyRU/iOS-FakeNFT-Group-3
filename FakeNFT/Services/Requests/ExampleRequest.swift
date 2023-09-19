import Foundation

struct ExampleRequest: NetworkRequest {
    var endpoint: URL?
}

struct UpdateRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod = .put
    var dto: Encodable?
}
