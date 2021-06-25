/// Google sign-in user account.
public struct GoogleUser: Codable, Equatable {
    public let accessToken: String
    public let expiresIn: Int
    public let idToken: String
    public let refreshToken: String?
    public let scope: String
    public let tokenType: String
}
