final class DefaultParallelMusicFetchForISRCsUseCase: ParallelMusicFetchForISRCsUseCase {
    private let musicKitService: any MusicKitService

    init(musicKitService: any MusicKitService) {
        self.musicKitService = musicKitService
    }
    
    func execute(isrcs: [String]) async throws -> [RandomMusic] {
        return try await withThrowingTaskGroup(of: RandomMusic?.self) { group in
            var musics: [RandomMusic] = []
            
            for isrc in isrcs {
                group.addTask { [weak self] in
                    return await self?.musicKitService.getMusic(with: isrc)
                }
            }
            
            for try await music in group {
                if let music {
                    musics.append(music)
                }
            }
            
            return musics
        }
    }
}
