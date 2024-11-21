import Foundation

protocol UpdatePlaylistUseCase {
    /// uuid값에 해당하는 플레이리스트 정보를 업데이트
    func execute(id: UUID, to updatedPlaylist: MolioPlaylist) async throws
}
