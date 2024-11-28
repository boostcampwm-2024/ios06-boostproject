import Foundation
import FirebaseCore

protocol PlaylistUseCase {
    // Fetch Playlists
    func fetchMyAllPlaylists() async throws -> [MolioPlaylist]
    func fetchAllPlaylists(userID: String) async throws -> [MolioPlaylist]
    func fetchPlaylist(playlistID: UUID) async throws -> MolioPlaylist
    
    // Music Management
    func fetchAllMusics( playlistID: UUID) async throws -> [MolioMusic]
    func addMusic( musicISRC: String, to playlistID: UUID) async throws
    func deleteMusic( musicISRC: String, from playlistID: UUID) async throws
    func moveMusic( musicISRC: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws
    
    // Playlist Management
    func createPlaylist( playlistName: String) async throws
    func updatePlaylistName(playlistID: String, name: String) async throws
    func updatePlaylistFilter(playlistID: String, filter: MusicFilter) async throws
    func deletePlaylist( playlistID: UUID) async throws

    // Playlist Interactions
    func likePlaylist(playlistID: UUID) async throws
    func unlikePlaylist(playlistID: UUID) async throws
}
// TODO: Delete this after the playlistService is merged
protocol MockPlaylistService {
    func createPlaylist(playlist: MockMolioPlaylistDTO) async throws
    func readPlaylist(playlistID: UUID) async throws -> MockMolioPlaylistDTO
    func readAllPlaylist(userID: String) async throws -> [MockMolioPlaylistDTO]
    func updatePlaylist(newPlaylist: MockMolioPlaylistDTO) async throws
    func deletePlaylist(playlistID: UUID) async throws
}

// TODO: Delete this after the playlistService is merged
struct MockMolioPlaylistDTO: Codable {
        let id: String      // 플레이리스트 고유 ID
        let authorID: String        // 플레이리스트 작성자 ID
        var title: String  // 플레이리스트 이름
        let createdAt: Timestamp       // 생성일
        var filters: [String]     // 필터
        var musicISRCs: [String]  // 음악 ISRC 리스트
        var likes: [String]         // 좋아요를 누른 사용자 ID 리스트

        func toDictionary() -> [String: Any]? {
            guard let data = try? JSONEncoder().encode(self),
                  let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                  let dictionary = jsonObject as? [String: Any] else {
                return nil
            }
            return dictionary
        }
    
    func toDomain() -> MolioPlaylist? {
        guard let uuid = UUID(uuidString: id) else {
            return nil
        }

        return MolioPlaylist(
            id: uuid,
            name: title,
            createdAt: createdAt.dateValue(),
            musicISRCs: musicISRCs,
            filter: filters,
            likes: likes
        )
    }
    
    func copy(
            id: String? = nil,
            authorID: String? = nil,
            title: String? = nil,
            createdAt: Timestamp? = nil,
            filters: [String]? = nil,
            musicISRCs: [String]? = nil,
            likes: [String]? = nil
        ) -> MockMolioPlaylistDTO {
            return MolioPlaylistDTO(
                id: id ?? self.id,
                authorID: authorID ?? self.authorID,
                title: title ?? self.title,
                createdAt: createdAt ?? self.createdAt,
                filters: filters ?? self.filters,
                musicISRCs: musicISRCs ?? self.musicISRCs,
                likes: likes ?? self.likes
            )
        }
    }
