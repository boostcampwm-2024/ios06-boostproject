import Foundation
import Combine
import MusicKit

final class SwipeMusicViewModel: InputOutputViewModel {
    struct Input {
        let musicCardDidChangeSwipe: AnyPublisher<CGFloat, Never>
        let musicCardDidFinishSwipe: AnyPublisher<CGFloat, Never>
        let likeButtonDidTap: AnyPublisher<Void, Never>
        let dislikeButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isLoading: AnyPublisher<Bool, Never> // TODO: 로딩 UI 구현 및 연결
        let buttonHighlight: AnyPublisher<ButtonHighlight, Never>
        let musicCardSwipeAnimation: AnyPublisher<SwipeDirection, Never>
        let currentMusicTrack: AnyPublisher<SwipeMusicTrackModel, Never>
        let nextMusicTrack: AnyPublisher<SwipeMusicTrackModel, Never>
        let error: AnyPublisher<String, Never> // TODO: Error에 따른 알림 UI 구현 및 연결
    }
    
    enum SwipeDirection: CGFloat {
        case left = -1.0
        case right = 1.0
        case none = 0
    }

    struct ButtonHighlight {
        let isLikeHighlighted: Bool
        let isDislikeHighlighted: Bool
    }

    var swipeThreshold: CGFloat {
        return 170.0
    }
    
    private let musicDeck: any MusicDeck
    private let fetchImageUseCase: FetchImageUseCase
    private let isLoadingPublisher = PassthroughSubject<Bool, Never>()
    private let buttonHighlightPublisher = PassthroughSubject<ButtonHighlight, Never>()
    private let musicCardSwipeAnimationPublisher = PassthroughSubject<SwipeDirection, Never>()
    private let currentMusicTrackPublisher = PassthroughSubject<SwipeMusicTrackModel, Never>()
    private let nextMusicTrackPublisher = PassthroughSubject<SwipeMusicTrackModel, Never>()
    private let errorPublisher = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchRecommendedMusicUseCase: FetchRecommendedMusicUseCase = DIContainer.shared.resolve(),
        fetchImageUseCase: FetchImageUseCase = DIContainer.shared.resolve(),
        musicFilterProvider: any MusicFilterProvider = MockMusicFilterProvider() // TODO: - 삭제
    ) {
        self.musicDeck = RandomMusicDeck(
            fetchRecommendedMusicUseCase: fetchRecommendedMusicUseCase,
            musicFilterProvider: musicFilterProvider
        )
        self.fetchImageUseCase = fetchImageUseCase
        setupBindings()
    }
    
    func transform(from input: Input) -> Output {
        input.musicCardDidChangeSwipe
            .map { [weak self] translation -> ButtonHighlight in
                guard let self else {
                    return ButtonHighlight(isLikeHighlighted: false, isDislikeHighlighted: false)
                }
                return ButtonHighlight(isLikeHighlighted: translation > self.swipeThreshold,
                                       isDislikeHighlighted: translation < -self.swipeThreshold
                )
            }
            .sink { [weak self] buttonHighlight in
                self?.buttonHighlightPublisher.send(buttonHighlight)
            }
            .store(in: &cancellables)

        input.musicCardDidFinishSwipe
            .map { [weak self] translation -> SwipeDirection in
                guard let self else { return .none }
                if translation > self.swipeThreshold {
                    self.musicDeck.likeCurrentMusic()
                    return .right
                } else if translation < -self.swipeThreshold {
                    self.musicDeck.dislikeCurrentMusic()
                    return .left
                } else {
                    return .none
                }
            }
            .sink { [weak self] swipeDirection in
                guard let self else { return }
                self.musicCardSwipeAnimationPublisher.send(swipeDirection)
                self.buttonHighlightPublisher.send(
                    ButtonHighlight(isLikeHighlighted: false,
                                    isDislikeHighlighted: false)
                )
            }
            .store(in: &cancellables)

        input.likeButtonDidTap
            .throttle(for: .seconds(0.4), scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self else { return }
                self.musicDeck.likeCurrentMusic()
                self.musicCardSwipeAnimationPublisher.send(.right)
            }
            .store(in: &cancellables)

        input.dislikeButtonDidTap
            .throttle(for: .seconds(0.4), scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self else { return }
                self.musicDeck.dislikeCurrentMusic()
                self.musicCardSwipeAnimationPublisher.send(.left)
            }
            .store(in: &cancellables)

        return Output(
            isLoading: isLoadingPublisher.eraseToAnyPublisher(),
            buttonHighlight: buttonHighlightPublisher.eraseToAnyPublisher(),
            musicCardSwipeAnimation: musicCardSwipeAnimationPublisher.eraseToAnyPublisher(),
            currentMusicTrack: currentMusicTrackPublisher.eraseToAnyPublisher(),
            nextMusicTrack: nextMusicTrackPublisher.eraseToAnyPublisher(),
            error: errorPublisher.eraseToAnyPublisher()
        )
    }
    
    private func setupBindings() {
        // MARK: 현재 노래 관련
        // currentMusicTrack이 변경되면 sink에 정의된 동작을 실행한다.
        musicDeck.currentMusicTrackModelPublisher
            .sink { [weak self] currentMusic in
                guard let currentMusic else {
                    // TODO: 현재 노래가 없는 경우 보여줄 카드 처리.
                    return
                }
                Task { [weak self] in
                    guard let self else { return }
                    do {
                        let swipeMusicTrackModel = try await self.loadMusicCard(from: currentMusic)
                        self.currentMusicTrackPublisher.send(swipeMusicTrackModel)
                    } catch {
                        self.currentMusicTrackPublisher.send(SwipeMusicTrackModel(
                            randomMusic: currentMusic,
                            imageData: nil)
                        )
                    }
                }
            }
            .store(in: &cancellables)
        
        // MARK: 다음 노래 관련
        musicDeck.nextMusicTrackModelPublisher
            .sink { [weak self] nextMusic in
                guard let nextMusic else {
                    // TODO: 다음 노래가 없는 경우 보여줄 카드 처리.
                    return
                }
                Task { [weak self] in
                    guard let self else { return }
                    do {
                        let swipeMusicTrackModel = try await self.loadMusicCard(from: nextMusic)
                        self.nextMusicTrackPublisher.send(swipeMusicTrackModel)
                    } catch {
                        self.currentMusicTrackPublisher.send(SwipeMusicTrackModel(
                            randomMusic: nextMusic,
                            imageData: nil)
                        )
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadMusicCard(from music: MolioMusic) async throws -> SwipeMusicTrackModel {
        guard let imageURL = music.artworkImageURL else {
            return SwipeMusicTrackModel(randomMusic: music, imageData: nil)
        }
        
        let imageData = try await fetchImageUseCase.execute(url: imageURL)

        return SwipeMusicTrackModel(randomMusic: music, imageData: imageData)
    }
}
