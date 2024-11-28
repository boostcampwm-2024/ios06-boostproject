import Combine
import Foundation
import FirebaseCore

final class DefaultPlaylistRepository: RealPlaylistRepository {
    private let playlistService: PlaylistService
    private let playlistStorage: PlaylistLocalStorage

    init(
        playlistService: PlaylistService = FirestorePlaylistService(),
        playlistStorage: PlaylistLocalStorage
    ) {
        self.playlistService = playlistService
        self.playlistStorage = playlistStorage
    }

    func addMusic(userID: String?, isrc: String, to playlistID: UUID) async throws {
        if userID != nil {
            let playlistDTO = try await playlistService.readPlaylist(playlistID: playlistID)
            
            let updatedPlaylist = playlistDTO.copy(musicISRCs: playlistDTO.musicISRCs + [isrc])
            
            try await playlistService.updatePlaylist(newPlaylist: updatedPlaylist)
        } else {
            guard let playlist = try await playlistStorage.read(by: playlistID.uuidString) else { return }
            let updatedPlaylist = MolioPlaylist(
                id: playlist.id,
                name: playlist.name,
                createdAt: playlist.createdAt,
                musicISRCs: playlist.musicISRCs + [isrc],
                filter: playlist.filter
            )
            try await playlistStorage.update(updatedPlaylist)
        }
    }

    func deleteMusic(userID: String?, isrc: String, in playlistID: UUID) async throws {
        if userID != nil {
            // Firestore에서 플레이리스트 읽기
            let playlistDTO = try await playlistService.readPlaylist(playlistID: playlistID)

            // 음악 ISRC 제거
            let updatedMusicISRCs = playlistDTO.musicISRCs.filter { $0 != isrc }
            
            let updatedPlaylist = playlistDTO.copy(musicISRCs: updatedMusicISRCs)

            // Firestore에 업데이트된 플레이리스트 저장
            try await playlistService.updatePlaylist(newPlaylist: updatedPlaylist)
        } else {
            guard let playlist = try await playlistStorage.read(by: playlistID.uuidString) else { return }
            let updatedPlaylist = MolioPlaylist(
                id: playlist.id,
                name: playlist.name,
                createdAt: playlist.createdAt,
                musicISRCs: playlist.musicISRCs.filter { $0 != isrc },
                filter: playlist.filter
            )
            try await playlistStorage.update(updatedPlaylist)
        }
    }

    func moveMusic(userID: String?, isrc: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws {
        if userID != nil {
            // TODO: Implement Firestore logic for moving music
            guard let playlist = try await playlistStorage.read(by: playlistID.uuidString) else { return }
            var newMusicISRCs = playlist.musicISRCs
            
            let music = newMusicISRCs.remove(at: fromIndex)
            newMusicISRCs.insert(music, at: toIndex)
            
            let updatedPlaylist = playlist.copy(musicISRCs: newMusicISRCs)
            
            let updatedPlaylistDTO = MolioPlaylistMapper.map(from: updatedPlaylist)
            
            try await playlistService.updatePlaylist(newPlaylist: updatedPlaylistDTO)
            
        } else {
            // TODO: Implement local storage logic for moving music
        }
    }

    func createNewPlaylist(userID: String?, playlistID: UUID, _ playlistName: String) async throws {
        if let userID = userID {
            // 새로운 플레이리스트 DTO 생성
            
            let newPlaylistDTO = MolioPlaylistDTO(
                id: playlistID.uuidString,
                authorID: userID,
                title: playlistName,
                createdAt: Timestamp(date: Date.now),
                filters: [],
                musicISRCs: [],
                likes: []
            )
            
            try await playlistService.createPlaylist(playlist: newPlaylistDTO)
            
        } else {
            let newPlaylist = MolioPlaylist(
                id: playlistID,
                name: playlistName,
                createdAt: Date(),
                musicISRCs: [],
                filter: MusicFilter(genres: [])
            )
            
            try await playlistStorage.create(newPlaylist)
        }
    }

    func deletePlaylist(userID: String?, _ playlistID: UUID) async throws {
        if userID != nil {
            try await playlistService.deletePlaylist(playlistID: playlistID)
        } else {
            try await playlistStorage.delete(by: playlistID.uuidString)
        }
    }

    func fetchPlaylists(userID: String?) async throws -> [MolioPlaylist]? {
        if let userID = userID {
            let molioPlaylistDTOs = try await playlistService.readAllPlaylist(userID: userID)
            
            let molioPlaylists: [MolioPlaylist] = molioPlaylistDTOs.compactMap { molioPlaylistDTO in
                MolioPlaylistMapper.map(from: molioPlaylistDTO)
            }
            
            return molioPlaylists
        } else {
            return try await playlistStorage.readAll()
        }
    }

    func fetchPlaylist(userID: String?, for playlistID: UUID) async throws -> MolioPlaylist? {
        if userID != nil {
            // TODO: Implement Firestore logic for fetching a single playlist
            
            let playlistDTO = try await playlistService.readPlaylist(playlistID: playlistID)
            
            guard let uuid = UUID(uuidString: playlistDTO.id) else {
                return nil
            }
            
            return MolioPlaylistMapper.map(from: playlistDTO)

        } else {
            return try await playlistStorage.read(by: playlistID.uuidString)
        }
    }

    func updatePlaylist(userID: String?, newPlaylist: MolioPlaylist) async throws {
        if userID != nil {
            let newPlaylistDTO = MolioPlaylistMapper.map(from: newPlaylist)
            
            try await playlistService.updatePlaylist(newPlaylist: newPlaylistDTO)
            
        } else {
            try await playlistStorage.update(newPlaylist)
        }
    }
}
