import Combine
import SwiftUI

final class PlaylistDetailViewModel: ObservableObject {
    enum ExportStatus {
        case preparing
        case inProgress
        case finished
        
        var displayText: String {
            switch self {
            case .preparing: "플레이리스트 내보내기 준비 중..."
            case .inProgress: "플레이리스트 생성 중..."
            case .finished: "플레이리스트 생성 완료!"
            }
        }
    }
    private let managePlaylistUseCase: ManageMyPlaylistUseCase
    private let appleMusicUseCase: AppleMusicUseCase
    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    
    @Published private(set) var isAppleMusicSubscriber: Bool = false
    @Published var currentPlaylist: MolioPlaylist?
    @Published var currentPlaylistMusics: [MolioMusic] = []
    @Published var exportStatus: ExportStatus = .preparing
    @Published var createdPlaylistURL: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        managePlaylistUseCase: ManageMyPlaylistUseCase = DefaultManageMyPlaylistUseCase(),
        appleMusicUseCase: any AppleMusicUseCase = DIContainer.shared.resolve(),
        fetchPlaylistUseCase: any FetchPlaylistUseCase = DIContainer.shared.resolve()
    ) {
        self.managePlaylistUseCase = managePlaylistUseCase
        self.appleMusicUseCase = appleMusicUseCase
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        
        bind()
    }

    private func bind() {
        managePlaylistUseCase.currentPlaylistPublisher()
            .receive(on: DispatchQueue.main)
            .sink { playlist in
                guard let playlist = playlist else { return }
                self.currentPlaylist = playlist
                Task { @MainActor [weak self] in
                    let playlistMusics = try await self?.fetchPlaylistUseCase.fetchAllMyMusicIn(playlistID: playlist.id)
                    self?.currentPlaylistMusics = playlistMusics ?? []
                }
            }
            .store(in: &subscriptions)
    }
    
    func checkAppleMusicSubscription() {
        Task { @MainActor [weak self] in
            let isSubscriber = try? await self?.appleMusicUseCase.checkSubscription()
            self?.isAppleMusicSubscriber = isSubscriber ?? false
        }
    }
    
    func exportMolioPlaylistToAppleMusic() {
        guard let currentPlaylist = currentPlaylist else { return }
        Task { @MainActor [weak self] in
            do {
                self?.exportStatus = .inProgress
                self?.createdPlaylistURL = try await self?.appleMusicUseCase.exportPlaylist(currentPlaylist)
            } catch {
                print(error.localizedDescription)
                self?.exportStatus = .finished
            }
            self?.exportStatus = .finished
        }
    }
    
    func openPlaylistWithAppleMusic() {
        guard let createdPlaylistURL = createdPlaylistURL,
              let url = URL(string: createdPlaylistURL) else {
            return
        }
        Task { @MainActor in
            await UIApplication.shared.open(url)
        }
    }
}
