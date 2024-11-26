@testable import Molio

final class MockNetworkProvider: NetworkProvider {
    var isErrorThrow: Bool = false
    var dtoToReturn: Decodable?
    var errorToThrow: Error?
    var isRequestCalled: Bool = false
    var requestCallCount: Int = 0
    
    func request<T: Decodable>(_ endPoint: any Molio.EndPoint) async throws -> T {
        requestCallCount += 1
        isRequestCalled = true
        if isErrorThrow {
            throw errorToThrow!
        } else {
            return dtoToReturn as! T
        }
    }
}
