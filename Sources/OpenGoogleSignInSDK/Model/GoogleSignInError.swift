import Foundation

/// Google sign-in error.
public enum GoogleSignInError: Error, Equatable {
    case authenticationError(Error)
    case invalidCode
    case invalidResponse
    case invalidTokenRequest
    case networkError(Error)
    case tokenDecodingError(Error)
    case userCancelledSignInFlow
    case noProfile(Error)
}

extension GoogleSignInError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .authenticationError(error):
            return "authenticationError, underlying error \(error.localizedDescription)"
        case .invalidCode:
            return "invalidCode"
        case .invalidResponse:
            return "invalidResponse"
        case .invalidTokenRequest:
            return "invalidTokenRequest"
        case let .networkError(error):
            return "network, underlying error \(error.localizedDescription)"
        case let .tokenDecodingError(error):
            return "tokenDecoding, underlying error \(error.localizedDescription)"
        case .userCancelledSignInFlow:
            return "userCancelledSignInFlow"
        case let .noProfile(error):
            return "noProfile, underlying error \(error.localizedDescription)"
        }
    }
}

public func == (lhs: Error, rhs: Error) -> Bool {
    guard type(of: lhs) == type(of: rhs) else { return false }
    let error1 = lhs as NSError
    let error2 = rhs as NSError
    return error1.domain == error2.domain && error1.code == error2.code && "\(lhs)" == "\(rhs)"
}

extension Equatable where Self : Error {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs as Error == rhs as Error
    }
}
