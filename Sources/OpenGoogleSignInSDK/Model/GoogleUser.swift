import Foundation

/// Google sign-in user account.
public struct GoogleUser: Codable, Equatable {
    
    /// User's profile info.
    ///
    /// All the properties are optional according
    /// to the [documentation](https://googleapis.dev/nodejs/googleapis/latest/oauth2/interfaces/Schema$Userinfo.html#info).
    public struct Profile: Codable, Equatable {
        
        /// The obfuscated ID of the user.
        public let id: String?
        
        /// The user's email address.
        public let email: String?
        
        /// Boolean flag which is true if the email address is verified.
        /// Always verified because we only return the user's primary email address.
        public let verifiedEmail: Bool?
        
        /// The user's full name.
        public let name: String?
        
        /// The user's first name.
        public let givenName: String?
        
        /// The user's last name.
        public let familyName: String?
        
        /// The user's gender.
        public let gender: String?
        
        /// URL of the profile page.
        public let link: URL?
        
        /// URL of the user's picture image.
        public let picture: URL?
        
        /// The hosted domain e.g. example.com if the user is Google apps user.
        public let hd: String?
        
        /// The user's preferred locale.
        public let locale: String?
    }

    public let accessToken: String
    public let expiresIn: Int
    public let idToken: String
    public let refreshToken: String?
    public let scope: String
    public let tokenType: String
    public var profile: Profile?
}
