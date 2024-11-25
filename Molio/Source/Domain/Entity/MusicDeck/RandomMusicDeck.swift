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
    
    /// 필터 변경 시 덱 초기화
    /// - `currentMusicFilter`(현재 필터) 변경
    /// - `randomMusics` 배열 비우기 (최대 2개까지 남겨준다.)
    func reset(with filter: MusicFilter) {
        print(#fileID, #function)
        currentMusicFilter = filter
        let cardCountToRemove = max(0, self.randomMusics.value.count - 2)
        randomMusics.value.removeLast(cardCountToRemove)
    }
}

// MARK: 프로토콜 요구사항을 위한 구현체

final class RandomMusicDeck {
    private let publishCurrentPlaylistUseCase: any PublishCurrentPlaylistUseCase
    private let fetchRecommendedMusicUseCase: any FetchRecommendedMusicUseCase
    
    private var currentMusicFilter: MusicFilter? = nil
    private let randomMusics: CurrentValueSubject<[MolioMusic], Never>
    private var cancellables = Set<AnyCancellable>()

    // MARK: 생성자
    
    init(
        publishCurrentPlaylistUseCase: any PublishCurrentPlaylistUseCase = DIContainer.shared.resolve(),
        fetchRecommendedMusicUseCase: any FetchRecommendedMusicUseCase = DIContainer.shared.resolve()
    ) {
        // 의존성 주입
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
            .map { $0?.filter }
            .sink { [weak self] currentPlaylistFilter in
                print("현재 플레이리스트 필터 받음!! \(currentPlaylistFilter)")
                self?.currentMusicFilter = currentPlaylistFilter
            }
            .store(in: &cancellables)
    }
    
    /// 현재 불러온 음악 개수가 10개 미만이 되면 추가로 불러온다.
    private func setupFetchMoreMusicCancellable() {
        randomMusics
            .map { $0.count }
            .sink { [weak self] musicCount in
                print("musicCount가 \(musicCount)임!!")
                if musicCount < 10 {
                    self?.loadRandomMusic()
                }
            }
            .store(in: &cancellables)
    }
    
    /// 현재 필터 기반으로 랜덤 추천 음악 불러오기
    private func loadRandomMusic() {
        print(#fileID, #function)
        let filter = currentMusicFilter ?? MusicFilter(genres: [])
        print("\(filter)로 랜덤 추천 음악을 다시 불러옵니다.")
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
