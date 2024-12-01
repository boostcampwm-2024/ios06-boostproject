import MusicKit

struct DefaultMusicKitService: MusicKitService {
    /// 애플 뮤직 구독 상태를 확인
    func checkSubscriptionStatus() async throws -> Bool {
        do {
            return try await MusicSubscription.current.canPlayCatalogContent
        } catch {
            throw MusicKitError.failedSubscriptionCheck
        }
    }
    
    /// ISRC 코드로 애플 뮤직 카탈로그 음악을 검색
    ///  - Parameters: 검색할 isrc 문자열
    ///  - Returns: 응답 데이터 (RandomMusic)
    func getMusic(with isrc: String) async -> MolioMusic? {
        guard checkAuthorizationStatus() else { return nil }
        
        guard let searchedSong = await searchSong(with: isrc) else { return nil }
        return SongMapper.toDomain(searchedSong)
    }
    
    func getMusic(with isrcs: [String]) async -> [MolioMusic] {
        return await withTaskGroup(of: (Int, MolioMusic?).self) { group in
            for (index, isrc) in isrcs.enumerated() {
                group.addTask {
                    let music = await getMusic(with: isrc)
                    return (index, music)
                }
            }
            
            var orderedMusics = [MolioMusic?](repeating: nil, count: isrcs.count)
            for await (index, music) in group {
                orderedMusics[index] = music
            }
            // nil인 경우 제외
            return orderedMusics.compactMap { $0 }
        }
    }
    
    /// 애플 뮤직 플레이리스트 내보내기
    func exportAppleMusicPlaylist(name: String, isrcs: [String]) async throws -> String? {
        guard checkAuthorizationStatus() else { throw MusicKitError.deniedPermission }
        
        let playlist = try await createPlaylist(name: name)
        for isrc in isrcs {
            guard let song = await searchSong(with: isrc) else { continue }
            do {
                try await addSong(song, to: playlist)
            } catch {
                continue
            }
        }
        return playlist.url?.absoluteString
    }
    
    /// 애플 뮤직 접근 권한 상태를 확인
    private func checkAuthorizationStatus() -> Bool {
        switch MusicAuthorization.currentStatus {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            Task {
                await requestAuthorization()
            }
            return false
        @unknown default:
            return false
        }
    }
    
    /// 애플 뮤직 접근 권한 요청
    private func requestAuthorization() async {
        _ = await MusicAuthorization.request()
    }
    
    /// 플레이리스트 생성
    /// - 생성에 실패한 경우 `MusicKitError.failedToCreatePlaylist` 에러를 throw
    private func createPlaylist(name: String) async throws -> MusicKit.Playlist {
        do {
            return try await MusicLibrary.shared.createPlaylist(name: name)
        } catch {
            throw MusicKitError.failedToCreatePlaylist(name: name)
        }
    }
    
    /// 플레이리스트에 노래 추가
    private func addSong(_ song: Song, to playlist: MusicKit.Playlist) async throws {
        try await MusicLibrary.shared.add(song, to: playlist)
    }
    
    /// 애플 뮤직에서 isrc 값으로 검색한 노래를 `MusicKit.Song` 타입으로 반환
    /// - 찾지 못한 경우 `nil`을 반환
    private func searchSong(with isrc: String) async -> Song? {
        let request = MusicCatalogResourceRequest<Song>(matching: \.isrc, equalTo: isrc)
        do {
            let response = try await request.response()
            guard let searchedMusic = response.items.first else {
                return nil
            }
            return searchedMusic
        } catch {
            return nil
        }
    }
}
