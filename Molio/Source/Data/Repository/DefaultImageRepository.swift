import Foundation

struct DefaultImageRepository: ImageRepository {
    private let imageFetchService: ImageFetchService
    
    init(
        imageFetchService: ImageFetchService = DIContainer.shared.resolve()
    ) {
        self.imageFetchService = imageFetchService
    }
    
    func fetchImage(from url: URL) async throws -> Data {
        return try await imageFetchService.fetchImage(from: url)
    }
}
