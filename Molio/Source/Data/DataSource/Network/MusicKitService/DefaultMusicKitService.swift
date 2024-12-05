import Foundation
import MusicKit

struct DefaultMusicKitService: MusicKitService {
    /// 애플 뮤직 권한 상태 확인
    func checkAuthorizationStatus() async throws {
        switch MusicAuthorization.currentStatus {
        case .authorized:
            break
        case .denied:
            throw MusicKitError.deniedPermission
        case .restricted:
            throw MusicKitError.restricted
        case .notDetermined:
            let status = await requestAuthorization()
            if status != .authorized {
                throw MusicKitError.deniedPermission
            }
        @unknown default:
            break
        }
    }
    
    /// 애플 뮤직 구독 상태를 확인
    func checkSubscriptionStatus() async throws -> Bool {
        do {
            return try await MusicSubscription.current.canPlayCatalogContent
        } catch {
            throw MusicKitError.failedSubscriptionCheck
        }
    }
    
    func fetchGenres() async throws -> [MusicGenre] {
        try await checkAuthorizationStatus()
        let request = MusicCatalogResourceRequest<Genre>()
        let response = try await request.response()
        return response.items.map(\.name)
    }
    
    /// 랜덤하게 추천 음악을 불러온다.
    /// - `genres` : 전달받은 장르에 해당하는 차트 음악들을 불러와서 랜덤하게 섞어서 반환
    func fetchRecommendedMusics(by genres: [MusicGenre]) async throws -> [MolioMusic] {
        try await checkAuthorizationStatus()
        var recommendedMusics: [MolioMusic] = []
        let musicKitGenres = try await convertToAppleMusicGenre(genres)
        
        // 설정된 장르가 없는 경우 Top Songs 차트의 음악 검색
        if musicKitGenres.isEmpty {
            let songs = try await getMusicCatalogChart()
            let molioMusics = songs.compactMap({ SongMapper.toDomain($0) })
            recommendedMusics += molioMusics
        } else {
            for genre in musicKitGenres {
                let songs = try await getMusicCatalogChart(of: genre)
                let molioMusics = songs.compactMap({ SongMapper.toDomain($0) })
                recommendedMusics += molioMusics
            }
        }
        return recommendedMusics.shuffled()
    }
    
    func getMusic(with isrcs: [String]) async throws -> [MolioMusic] {
        try await checkAuthorizationStatus()
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
        try await checkAuthorizationStatus()
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
    
    // MARK: - Private methods
    
    /// 애플 뮤직 접근 권한 요청
    private func requestAuthorization() async -> MusicAuthorization.Status {
        let status = await MusicAuthorization.request()
        return status
    }
    
    /// ISRC 코드로 애플 뮤직 카탈로그 음악을 검색
    ///  - Parameters: 검색할 isrc 문자열
    ///  - Returns: 응답 데이터 (RandomMusic)
    private func getMusic(with isrc: String) async -> MolioMusic? {
        try? await checkAuthorizationStatus()
        guard let searchedSong = await searchSong(with: isrc) else { return nil }
        return SongMapper.toDomain(searchedSong)
    }
    
    /// 플레이리스트 생성
    /// - 생성에 실패한 경우 `MusicKitError.failedToCreatePlaylist` 에러를 throw
    private func createPlaylist(name: String) async throws -> MusicKit.Playlist {
        do {
            let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
            return try await MusicLibrary.shared.createPlaylist(name: name, authorDisplayName: appName)
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
    
    /// 애플 뮤직 카탈로그의 차트 음악들을 불러온다.
    /// - `genre` : 해당 차트 음악들을 불러옴
    /// - `kinds` : 불러올 차트 종류 지정 (Daily Top 100, City Charts, Top Playlists)
    private func getMusicCatalogChart(of appleMusicGenre: Genre? = nil) async throws -> [Song] {
        var request = MusicCatalogChartsRequest(
            genre: appleMusicGenre,
            kinds: [.dailyGlobalTop, .cityTop, .mostPlayed],
            types: [Song.self]
        )
        request.limit = 200
        let response = try await request.response()
        return response.songCharts.flatMap(\.items)
    }
    
    /// id 값을 통해 `MusicGenre(String)`의 배열을 MusicKit의 `Genre` 로 변환
    private func convertToAppleMusicGenre(_ genres: [MusicGenre]) async throws -> [Genre] {
        let request = MusicCatalogResourceRequest<Genre>()
        let response = try await request.response()
        let allAppleMusicGenres = response.items
        let filteredAppleMusicGenres = genres.compactMap { genreName in
            allAppleMusicGenres.first(where: { $0.name == genreName })
        }
        return filteredAppleMusicGenres
    }
}
