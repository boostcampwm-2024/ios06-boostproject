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
        removeCurrentMusic()
        // TODO: 현재 노래에 대한 좋아요 로직
    }
    
    func dislikeCurrentMusic() {
        removeCurrentMusic()
        // TODO: 현재 노래에 대한 싫어요 로직
    }
}

// MARK: 프로토콜 요구사항을 위한 구현체

final class RandomMusicDeck {
    
    // MARK: 의존성
    
    private var fetchRecommendedMusicUseCase: any FetchRecommendedMusicUseCase
    private var musicFilterProvider: any MusicFilterProvider
    
    // MARK: 생성자에서 초기화하는 프로퍼티
    
    var randomMusics: CurrentValueSubject<[MolioMusic], Never>
    private var musicFilter: CurrentValueSubject<MusicFilter?, Never>
    
    // MARK: Cancellable들
    
    private var fetchMoreMusicCancellable: AnyCancellable?
    private var fetchMusicWhenMusicFilterChangedCancellable: AnyCancellable?

    // MARK: 생성자
    
    init(
        fetchRecommendedMusicUseCase: any FetchRecommendedMusicUseCase = DIContainer.shared.resolve(),
        musicFilterProvider: any MusicFilterProvider = MockMusicFilterProvider()  // TODO: - 필터 전달받기
    ) {
        // 의존성 주입
        self.fetchRecommendedMusicUseCase = fetchRecommendedMusicUseCase
        self.musicFilterProvider = musicFilterProvider
        
        // 속성 초기화
        self.randomMusics = CurrentValueSubject([])
        self.musicFilter = CurrentValueSubject(nil)
        
        // 구독 설정
        setUpFetchMoreMusicCancellable()
        setUpFetchMusicWhenMusicFilterChangedCancellable()
    }
    
    // MARK: 구독
    
    // Sink에서 하는 행동을 위주로 이름지었다.
    private func setUpFetchMoreMusicCancellable() {
        self.fetchMoreMusicCancellable = self.randomMusics
            .sink { [weak self] randomMusic in
                if randomMusic.count < 10 {
                    self?.loadRandomMusic()
                }
            }
    }
    
    // 필터 프로바이더의 필터가 변경되는 경우 deck에서도 필터를 바꾼다.
    private func setUpFetchMusicWhenMusicFilterChangedCancellable() {
        self.fetchMusicWhenMusicFilterChangedCancellable = musicFilterProvider.getMusicFilterPublisher()
            .removeDuplicates { musicFilterBefore, musicFilterAfter in
                musicFilterBefore.genres == musicFilterAfter.genres
            }
            .sink { [weak self] musicFilter in
                guard let self else { return }
                
                self.musicFilter.value = musicFilter
                
                let cardCountToRemove = max(0, self.randomMusics.value.count - 2)
                
                // 2개 빼고 다 제거 (덱의 노래 카드를 다 제거하면 아무 것도 보이지 않는 상태로 꽤 오래 기다려야 할 수도 있다)
                self.randomMusics.value.removeLast(cardCountToRemove)
                
                self.loadRandomMusic()
            }
    }
    
    private func loadRandomMusic() {
        Task { [weak self] in
            let fetchedMusics = try? await self?.fetchRecommendedMusicUseCase.execute(with: MusicFilter(genres: []))
            
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
