import AuthenticationServices
import OSLog
import UIKit

/// Google sign-in delegate.
public protocol OpenGoogleSignInDelegate: AnyObject {
    /// Indicates that sign-in flow has finished and retrieves `GoogleUser` if successful or `error`.
    func sign(didSignInFor user: GoogleUser?, withError error: GoogleSignInError?)
}

/// Signs the user in with Google using OAuth 2.0.
public final class OpenGoogleSignIn: NSObject {
    
    // MARK: - Public properties
    
    public weak var delegate: OpenGoogleSignInDelegate?
    
    /// The client ID of the app.
    /// It is required for communication with Google API to work.
    public var clientID: String = ""
    
    /// Client secret.
    /// It is only used when exchanging the authorization code for an access token.
    public var clientSecret: String = ""
    
    /// `URLSession` used to perform data tasks.
    public var session: URLSession = URLSession.shared
    
    /// Shared `OpenGoogleSignIn` instance
    public static let shared: OpenGoogleSignIn = OpenGoogleSignIn()
    
    /// API scopes requested by the app
    public var scopes: Set<GoogleSignInScope> = [.email, .openID, .profile]
    
    /// View controller to present Google sign-in flow.
    /// Needs to be set for presenting to work correctly.
    public weak var presentingViewController: UIViewController? = nil
    
    // MARK: - Private properties

    /// Session used to authenticate a user with Google sign-in.
    private var authenticationSession: ASWebAuthenticationSession? = nil
    
    /// Google API OAuth 2.0 token url.
    private static let tokenURL: URL? = URL(string: "https://www.googleapis.com/oauth2/v4/token")

    /// The client's redirect URI, which is based on `clientID`.
    private var redirectURI: String {
        String(
            clientID
                .components(separatedBy: ".")
                .reversed()
                .joined(separator: ".")
        ) + ":/oauth2redirect/google"
    }
    
    /// Authorization `URL` based on parameters provided by the app.
    private var authURL: URL {
        let scopes = scopes.map { $0.rawValue }.joined(separator: "+")
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "accounts.google.com"
        components.path = "/o/oauth2/v2/auth"
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scopes)
        ]

        return components.url!
    }
    
    // MARK: - Initialization
    
    private override init() { }
    
    // MARK: - Public helpers
    
    
    /// Handles token response.
    /// Calls `OpenGoogleSignInDelegate` with valid response or error.
    public func handle(_ url: URL) {
        handleTokenResponse(using: url) { [weak self] result in
            switch result {
            case .success(let response):
                self?.delegate?.sign(didSignInFor: response, withError: nil)
            case .failure(let error):
                self?.delegate?.sign(didSignInFor: nil, withError: error)
            }
        }
    }

    /// Starts Google sign-in flow.
    /// `OpenGoogleSignInDelegate` will be called on success/error.
    public func signIn() {
        guard !clientID.isEmpty else {
            os_log(.error, "You must specify clientID for Google sign-in to work correctly!")
            return
        }

        // Create authentication session with provided parameters
        authenticationSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: clientID
        ) { [weak self] callbackURL, error in
            guard let callbackURL = callbackURL else { return }

            if let error = error {
                // Throw error if received
                self?.delegate?.sign(didSignInFor: nil, withError: .authenticationError(error))
            } else {
                // Handle received `callbackURL` on success
                self?.handle(callbackURL)
            }
        }
        
        // Set `presentationContextProvider` for iOS 13+ modals to work correctly
        if #available(iOS 13.0, *) {
            authenticationSession?.presentationContextProvider = self
        }
        
        // Start authentication session
        authenticationSession?.start()
    }
    
    // MARK: - Private helpers
    
    /// Decodes `GoogleUser` from OAuth 2.0 response.
    private func decodeUser(from data: Data) throws -> GoogleUser {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(GoogleUser.self, from: data)
    }
    
    /// Handles OAuth 2.0 token response.
    private func handleTokenResponse(using redirectUrl: URL, completion: @escaping (Result<GoogleUser, GoogleSignInError>) -> Void) {
        guard let code = self.parseCode(from: redirectUrl) else {
            completion(.failure(.invalidCode))
            return
        }
        
        guard let tokenRequest = makeTokenRequest(with: code) else {
            completion(.failure(.invalidTokenRequest))
            return
        }
        
        let task = session.dataTask(with: tokenRequest) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                completion(.success(try self.decodeUser(from: data)))
            } catch {
                completion(.failure(.tokenDecodingError(error)))
            }
        }
        task.resume()
    }
    
    /// Returns `code` parsed from provided `redirectURL`.
    private func parseCode(from redirectURL: URL) -> String? {
        let components = URLComponents(url: redirectURL, resolvingAgainstBaseURL: false)

        return components?.queryItems?.first(where: { $0.name == "code" })?.value
    }
    
    /// Returns `URLRequest` to retrieve Google sign-in OAuth 2.0 token using arameters provided by the app.
    private func makeTokenRequest(with code: String) -> URLRequest? {
        guard let tokenURL = OpenGoogleSignIn.tokenURL else { return nil }
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": code,
            "grant_type": "authorization_code",
            "redirect_uri": redirectURI
        ]
        
        let body = parameters
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
        
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding

extension OpenGoogleSignIn: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
