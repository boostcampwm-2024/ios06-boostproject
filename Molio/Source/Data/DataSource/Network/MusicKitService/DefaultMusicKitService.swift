import MusicKit

struct DefaultMusicKitService: MusicKitService {
    /// ISRC 코드로 애플 뮤직 카탈로그 음악을 검색
    ///  - Parameters: 검색할 isrc 문자열
    ///  - Returns: 응답 데이터 (RandomMusic)
    func getMusic(with isrc: String) async -> MolioMusic? {
        guard checkAuthorizationStatus() else { return nil }
        
        let request = MusicCatalogResourceRequest<Song>(matching: \.isrc, equalTo: isrc)
        do {
            let response = try await request.response()
            guard let searchedMusic = response.items.first else {
                return nil
            }
            return SongMapper.toDomain(searchedMusic)
        } catch {
            return nil
        }
    }
    
    func getMusic(with isrcs: [String]) async -> [MolioMusic] {
        return await withTaskGroup(of: MolioMusic?.self) { group in
            var musics: [MolioMusic] = []
            for isrc in isrcs {
                group.addTask { [weak self] in
                    return await self?.getMusic(with: isrc)
                }
            }
            
            for await music in group {
                if let music {
                    musics.append(music)
                }
            }
            
            return musics
        }

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
}
