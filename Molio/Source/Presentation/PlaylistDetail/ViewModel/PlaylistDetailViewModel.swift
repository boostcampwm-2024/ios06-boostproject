import Combine
import SwiftUI

final class PlaylistDetailViewModel: ObservableObject {
    private let publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase
    private let musicKitService: MusicKitService // TODO: - 유즈케이스 분리
    
    @Published var currentPlaylist: MolioPlaylist?
    @Published var currentPlaylistMusics: [MolioMusic] = [] {
        didSet {
            print("currentPlaylistMusics 수정됨: \(currentPlaylistMusics)")
        }
    }
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        publishCurrentPlaylistUseCase: any PublishCurrentPlaylistUseCase = DIContainer.shared.resolve(),
        musicKitService: any MusicKitService = DIContainer.shared.resolve()
    ) {
        self.publishCurrentPlaylistUseCase = publishCurrentPlaylistUseCase
        self.musicKitService = musicKitService
        
        bind()
    }

    private func bind() {
        publishCurrentPlaylistUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { playlist in
                guard let playlist = playlist else { return }
                self.currentPlaylist = playlist
                print("현재 플레이리스트 노래 개수: \(playlist.musicISRCs.count)")
                Task { @MainActor [weak self] in
                    let playlistMusics = await self?.musicKitService.getMusic(with: playlist.musicISRCs) ?? []
                    // TODO: - 실제 플레이리스트 노래를 불러와야 함
//                    self?.currentPlaylistMusics = playlistMusics
                    self?.currentPlaylistMusics = MolioMusic.all
                }
            }
            .store(in: &subscriptions)
    }
}
