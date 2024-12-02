import Combine
import Foundation

final class SplahViewModel: InputOutputViewModel {
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let navigateToNextScreen: AnyPublisher<NextScreenType, Never>
    }
    
    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    private let managePlaylistUseCase: ManageMyPlaylistUseCase
    private let manageAuthenticationUseCase: ManageAuthenticationUseCase
    private let navigateToNextScreenPublisher = PassthroughSubject<NextScreenType, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve(),
        managePlaylistUseCase: ManageMyPlaylistUseCase = DIContainer.shared.resolve(),
        manageAuthenticationUseCase: ManageAuthenticationUseCase = DIContainer.shared.resolve()
    ) {
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.managePlaylistUseCase = managePlaylistUseCase
        self.manageAuthenticationUseCase = manageAuthenticationUseCase
    }
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .flatMap { [weak self] _ -> AnyPublisher<NextScreenType, Never> in
                guard let self else { return Just(NextScreenType.login).eraseToAnyPublisher() }
                
                /// 스플래쉬 화면 최소 시간
                let delayPublisher = Just(())
                    .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
                
                /// 로그인, 게스트 모드를 선택했는지 여부 확인
                let nextScreenPublisher = Just(
                    self.manageAuthenticationUseCase.isAuthModeSelected()
                    ? NextScreenType.main
                    : NextScreenType.login
                )
                
                /// 현재 최소 플
                let playlistCheckPublisher = Future<Void, Never> { promise in
                    Task {
                        let sholudCreateDefaultPlaylist = try await self.shouldCreateDefaultPlaylist()
                        if sholudCreateDefaultPlaylist {
                            try await self.makeDefaultPlayList()
                        }
                        promise(.success(()))
                    }
                }
                
                return Publishers.CombineLatest3(delayPublisher, nextScreenPublisher, playlistCheckPublisher)
                    .map { _, nextScreen, _ in nextScreen }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] nextScreen in
                self?.navigateToNextScreenPublisher.send(nextScreen)
            }
            .store(in: &cancellables)
        
        return Output(navigateToNextScreen: navigateToNextScreenPublisher.eraseToAnyPublisher())
    }
    
    /// 기본 플레이리스트 생성해야하는지 여부를 나타내는 메서드
    private func shouldCreateDefaultPlaylist() async throws -> Bool {
        try await fetchPlaylistUseCase.fetchMyAllPlaylists().isEmpty
    }
    
    /// 기본 플레이리스트를 생성하는 메서드
    private func makeDefaultPlayList() async throws {
        try await managePlaylistUseCase.createPlaylist(playlistName: "기본 플레이리스트")
    }
    
    enum NextScreenType {
        case login
        case main
    }
}
