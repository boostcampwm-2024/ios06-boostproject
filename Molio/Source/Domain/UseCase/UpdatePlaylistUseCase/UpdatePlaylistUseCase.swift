import Foundation

protocol UpdatePlaylistUseCase {
    /// uuid값에 해당하는 플레이리스트 정보를 업데이트
    func execute(of id: UUID, name: String?, filter: MusicFilter?, musicISRCs: [String]?, like: [String]?) async throws
}
