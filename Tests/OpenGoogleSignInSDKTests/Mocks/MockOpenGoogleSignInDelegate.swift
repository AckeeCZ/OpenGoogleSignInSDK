import XCTest
@testable import OpenGoogleSignInSDK

final class MockOpenGoogleSignInDelegate: OpenGoogleSignInDelegate {
    var user: GoogleUser?
    var error: GoogleSignInError?

    private var expectation: XCTestExpectation?
    private let testCase: XCTestCase

    init(testCase: XCTestCase) {
        self.testCase = testCase
    }

    func expectSignInFinish() {
        expectation = testCase.expectation(description: "Expect sign-in flow to finish")
    }

    // MARK: - OAuthGoogleSignInDelegate

    func sign(didSignInFor user: GoogleUser?, withError error: GoogleSignInError?) {
        self.user = user
        self.error = error

        expectation?.fulfill()
    }
}
