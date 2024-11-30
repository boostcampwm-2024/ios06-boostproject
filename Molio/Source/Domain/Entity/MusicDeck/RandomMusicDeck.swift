import Combine

// MARK: 프로토콜 요구사항

extension RandomMusicDeck: MusicDeck {
    var currentMusicTrackModelPublisher: AnyPublisher<MolioMusic?, Never> {
        return musicPublisher(at: 0)
    }
    
    var nextMusicTrackModelPublisher: AnyPublisher<MolioMusic?, Never> {
        return musicPublisher(at: 1)
    }

    func likeCurrentMusic() {
        Task {
            if let currentMusic = randomMusics.value.first,
               let currentPlaylist = currentPlaylist {
                try await manageMyPlaylistUseCase.addMusic(musicISRC: currentMusic.isrc, to: currentPlaylist.id)
            }
        }
        removeCurrentMusic()
    }
    
    func dislikeCurrentMusic() {
        removeCurrentMusic()
    }
    
    /// 필터 변경 시 덱 초기화
    /// - `currentMusicFilter`(현재 필터) 변경
    /// - `randomMusics` 배열 비우기 (최대 2개까지 남겨준다.)
    func reset(with filter: MusicFilter) {
        currentMusicFilter = filter
        let cardCountToRemove = max(0, self.randomMusics.value.count - 2)
        randomMusics.value.removeLast(cardCountToRemove)
    }
}

// MARK: 프로토콜 요구사항을 위한 구현체

final class RandomMusicDeck {
    private let manageMyPlaylistUseCase: any ManageMyPlaylistUseCase
    private let publishCurrentPlaylistUseCase: any PublishCurrentPlaylistUseCase
    private let fetchRecommendedMusicUseCase: any FetchRecommendedMusicUseCase
    
    private let randomMusics: CurrentValueSubject<[MolioMusic], Never>
    private var cancellables = Set<AnyCancellable>()
    
    private var currentMusicFilter: MusicFilter?
    private var currentPlaylist: MolioPlaylist?

    // MARK: 생성자
    
    init(
        manageMyPlaylistUseCase: any ManageMyPlaylistUseCase = DefaultManageMyPlaylistUseCase(
            currentUserIdUseCase: DefaultCurrentUserIdUseCase(
                authService: DefaultFirebaseAuthService(),
                usecase: DefaultManageAuthenticationUseCase()),
            repository: DefaultPlaylistRepository(
                playlistService: FirestorePlaylistService(),
                playlistStorage: CoreDataPlaylistStorage())),
        publishCurrentPlaylistUseCase: any PublishCurrentPlaylistUseCase = DIContainer.shared.resolve(),
        fetchRecommendedMusicUseCase: any FetchRecommendedMusicUseCase = DIContainer.shared.resolve()
    ) {
        // 의존성 주입
        self.manageMyPlaylistUseCase = manageMyPlaylistUseCase
        self.publishCurrentPlaylistUseCase = publishCurrentPlaylistUseCase
        self.fetchRecommendedMusicUseCase = fetchRecommendedMusicUseCase
        
        // 속성 초기화
        self.randomMusics = CurrentValueSubject([])
        
        // 구독 설정
        setupCurrentPlaylistCancellable()
        setupFetchMoreMusicCancellable()
    }
    
    // MARK: 구독
    
    /// 현재 플레이리스트의 필터 정보 불러오기
    private func setupCurrentPlaylistCancellable() {
        publishCurrentPlaylistUseCase.execute()
            .sink { [weak self] currentPlaylist in
                self?.currentPlaylist = currentPlaylist
                self?.currentMusicFilter = currentPlaylist?.filter
            }
            .store(in: &cancellables)
    }
    
    /// 현재 불러온 음악 개수가 10개 미만이 되면 추가로 불러온다.
    private func setupFetchMoreMusicCancellable() {
        randomMusics
            .map { $0.count }
            .sink { [weak self] musicCount in
                if musicCount < 10 {
                    self?.loadRandomMusic()
                }
            }
            .store(in: &cancellables)
    }
    
    /// 현재 필터 기반으로 랜덤 추천 음악 불러오기
    private func loadRandomMusic() {
        let filter = currentMusicFilter ?? MusicFilter(genres: [])
        Task { [weak self] in
            let fetchedMusics = try? await self?.fetchRecommendedMusicUseCase.execute(with: filter)
            
            guard let fetchedMusics else { return }
            
            self?.randomMusics.value.append(contentsOf: fetchedMusics)
        }
    }
    
    private func removeCurrentMusic() {
        guard !randomMusics.value.isEmpty else { return }
        
        randomMusics.value.remove(at: 0)
    }
    
    private func musicPublisher(at index: Int) -> AnyPublisher<MolioMusic?, Never> {
        randomMusics
            .compactMap { randomMusics in
                // 인덱스 범위를 벗어나지 않는지 체크하는 로직이다.
                guard randomMusics.count > index else { return nil }
                
                return randomMusics[index]
            }
            .removeDuplicates { $0?.isrc == $1?.isrc }
            .eraseToAnyPublisher()
    }
}
