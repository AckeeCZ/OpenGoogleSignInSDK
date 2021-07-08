import Foundation

extension JSONDecoder {
    /// Framework's setup of the `JSONDecoder`
    /// tailored for its use
    static let app: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
