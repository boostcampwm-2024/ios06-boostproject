import Combine
import SwiftUI

final class PlaylistDetailViewModel: ObservableObject {
    private let publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase
    private let checkAppleMusicSubscriptionUseCase: CheckAppleMusicSubscriptionUseCase
    private let exportAppleMusicPlaylistUseCase: ExportAppleMusicPlaylistUseCase
    private let musicKitService: MusicKitService // TODO: - 유즈케이스 분리
    
    @Published private(set) var isAppleMusicSubscriber: Bool = false
    @Published var currentPlaylist: MolioPlaylist?
    @Published var currentPlaylistMusics: [MolioMusic] = []
    @Published var isExporting: Bool = false
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        publishCurrentPlaylistUseCase: any PublishCurrentPlaylistUseCase = DIContainer.shared.resolve(),
        checkAppleMusicSubscriptionUseCase: any CheckAppleMusicSubscriptionUseCase = DIContainer.shared.resolve(),
        exportAppleMusicPlaylistUseCase: any ExportAppleMusicPlaylistUseCase = DIContainer.shared.resolve(),
        musicKitService: any MusicKitService = DIContainer.shared.resolve()
    ) {
        self.publishCurrentPlaylistUseCase = publishCurrentPlaylistUseCase
        self.checkAppleMusicSubscriptionUseCase = checkAppleMusicSubscriptionUseCase
        self.exportAppleMusicPlaylistUseCase = exportAppleMusicPlaylistUseCase
        self.musicKitService = musicKitService
        
        bind()
    }

    private func bind() {
        publishCurrentPlaylistUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { playlist in
                guard let playlist = playlist else { return }
                self.currentPlaylist = playlist
                Task { @MainActor [weak self] in
                    let playlistMusics = await self?.musicKitService.getMusic(with: playlist.musicISRCs) ?? []
                    self?.currentPlaylistMusics = playlistMusics
                }
            }
            .store(in: &subscriptions)
    }
    
    func checkAppleMusicSubscription() {
        Task { @MainActor [weak self] in
            let isSubscriber = try? await self?.checkAppleMusicSubscriptionUseCase.execute()
            self?.isAppleMusicSubscriber = isSubscriber ?? false
        }
    }
    
    func exportMolioPlaylistToAppleMusic() {
        isExporting = true
        guard let currentPlaylist = currentPlaylist else { return }
        Task { @MainActor [weak self] in
            do {
                try await self?.exportAppleMusicPlaylistUseCase.execute(currentPlaylist)
            } catch {
                print(error.localizedDescription)
                self?.isExporting = false
            }
            self?.isExporting = false
        }
    }
}
