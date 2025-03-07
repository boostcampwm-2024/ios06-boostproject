import Combine
import Foundation

// MARK: 프로토콜 요구사항을 위한 구현체

final class DefaultRandomMusicDeck: RandomMusicDeck {
    // MARK: - 프로토콜 준수
    var currentMusic: MolioMusic? {
        return randomMusics.value.first
    }
    
    var currentMusicTrackModelPublisher: AnyPublisher<MolioMusic?, Never> {
        return musicPublisher(at: 0)
    }
    
    var nextMusicTrackModelPublisher: AnyPublisher<MolioMusic?, Never> {
        return musicPublisher(at: 1)
    }
    
    var isPreparingMusicDeckPublisher: AnyPublisher<Bool, Never> {
        return preparingPublisher()
    }
    
    // MARK: Private 속성
    
    private let manageMyPlaylistUseCase: ManageMyPlaylistUseCase
    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    private let fetchRecommendedMusicUseCase: FetchRecommendedMusicUseCase
    
    // 이 친구는 main thread에서만 바꾸기로 한다 (꼭 그럴 필요는 없지만 스레드는 지정해야 한다.)
    private let randomMusics: CurrentValueSubject<[MolioMusic], Never>
    private var cancellables = Set<AnyCancellable>()
    
    private var currentMusicFilter: [MusicGenre]?
    private var currentPlaylist: MolioPlaylist?
    
    // MARK: 생성자
    
    init(
        manageMyPlaylistUseCase: ManageMyPlaylistUseCase = DIContainer.shared.resolve(),
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve(),
        fetchRecommendedMusicUseCase: FetchRecommendedMusicUseCase = DIContainer.shared.resolve()
    ) {
        self.manageMyPlaylistUseCase = manageMyPlaylistUseCase
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.fetchRecommendedMusicUseCase = fetchRecommendedMusicUseCase
        
        self.randomMusics = CurrentValueSubject([])
        
        setupCurrentPlaylistCancellable()
        setupFetchMoreMusicCancellable()
    }
    
    // MARK: - 카드 좋아요 / 싫어요 하기

    // 적어도 이거 호출하는 쪽은 MainActor어야 한다.
    func likeCurrentMusic() {
        // 무시하는 상황 (일어나지 않는다)
        
        guard let currentPlaylist else { return }
        guard let poppedMusicCard = popCurrentMusic() else { return }
        
        // 이미 있는 카드는 절대 추가하지 않는다.
        guard !currentPlaylist.musicISRCs.contains(poppedMusicCard.isrc) else {
            print("이미 있는 카드는 추가할 수 없습니다.")
            return
        }
        
        // 이미 넘긴 카드에 대한 처리는 비동기적으로 진행한다.
        Task { [weak self] in
            do {
                try await self?.manageMyPlaylistUseCase
                    .addMusic(
                        musicISRC: poppedMusicCard.isrc,
                        to: currentPlaylist.id
                    )
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func dislikeCurrentMusic() {
        _ = popCurrentMusic()
    }
    
    func reset(with filter: [MusicGenre]) {
        currentMusicFilter = filter
        randomMusics.value = []
    }

    private func setupCurrentPlaylistCancellable() {
        manageMyPlaylistUseCase
            .currentPlaylistPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentPlaylist in
                self?.currentPlaylist = currentPlaylist
                self?.currentMusicFilter = currentPlaylist?.filter
            }
            .store(in: &cancellables)
    }
    
    private func setupFetchMoreMusicCancellable() {
        randomMusics
            .map { $0.count }
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] musicCount in
                if musicCount < 10 {
                    self?.loadRandomMusic()
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadRandomMusic() {
        let filter = currentMusicFilter ?? []
        
        Task { [weak self] in
            do {
                // 추천 노래를 받아온다.
                let fetchedMusics = try await self?.fetchRecommendedMusicUseCase.execute(with: filter)

                guard let fetchedMusics else { return }

                // 현재 플리의 노래들
                let currentPlaylistmusics: [String] = self?.currentPlaylist?.musicISRCs ?? []
                
                // 이미 플리에 있는 노래는 추천받지 않는다.
                let filteredMusics = fetchedMusics.filter { music in
                    return !currentPlaylistmusics.contains(music.isrc)
                }
                
                // 중복 제거 (Hashable이 아니라서 이렇게 함)
                let uniqueFilteredMusics = Array(
                    Dictionary(grouping: filteredMusics, by: { $0.isrc })
                        .compactMap { $0.value.first }
                )

                // 덱의 노래들에 넣는다.
                DispatchQueue.main.async { [weak self] in
                    self?.randomMusics.value.append(contentsOf: uniqueFilteredMusics)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // 이거는 항상 main actor 에서 실행해야 한다.
    private func popCurrentMusic() -> MolioMusic? {
        guard !randomMusics.value.isEmpty else { return nil }
        
        return randomMusics.value.remove(at: 0)
    }
    
    private func musicPublisher(at index: Int) -> AnyPublisher<MolioMusic?, Never> {
        randomMusics
            .receive(on: DispatchQueue.main)
            .compactMap { randomMusics in
                guard randomMusics.count > index else { return nil }
                
                return randomMusics[index]
            }
            .removeDuplicates { $0?.isrc == $1?.isrc }
            .eraseToAnyPublisher()
    }
    
    private func preparingPublisher() -> AnyPublisher<Bool, Never> {
        randomMusics
            .map { randomMusics in
                randomMusics.isEmpty
            }
            .eraseToAnyPublisher()
    }
}
