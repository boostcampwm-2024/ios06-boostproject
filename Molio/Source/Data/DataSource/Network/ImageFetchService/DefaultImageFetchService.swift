import Foundation

final class DefaultImageFetchService: ImageFetchService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchImage(from url: URL) async throws -> Data {
        do {
            let (data, _) = try await session.data(from: url)
            guard !data.isEmpty else {
                throw ImageFecthError.noData
            }
            return data
        } catch URLError.badURL {
            throw ImageFecthError.invalidURL
        } catch {
            throw ImageFecthError.networkError
        }
    }
}
