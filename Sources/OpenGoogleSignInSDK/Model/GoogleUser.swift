import Foundation

/// Google sign-in user account.
public struct GoogleUser: Codable, Equatable {
    public struct Profile: Codable, Equatable {
        public let id: String
        public let email: String
        public let verifiedEmail: Bool
        public let name: String
        public let givenName: String
        public let familyName: String
        public let picture: URL
        public let locale: String
        public let hd: String
    }

    public let accessToken: String
    public let expiresIn: Int
    public let idToken: String
    public let refreshToken: String?
    public let scope: String
    public let tokenType: String
    public var profile: Profile?
}
