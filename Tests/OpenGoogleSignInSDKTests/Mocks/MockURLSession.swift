import Foundation

final class MockURLSession: URLSession {
    var data: Data?
    var error: Error?
    
    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        
        return MockURLSessionDataTask {
            completionHandler(data, nil, error)
        }
    }
}
