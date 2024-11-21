import SwiftUI
import Combine

final class PlaylistDetailViewModel: ObservableObject {
    @Published var currentPlaylist: MolioPlaylist?
    @Published var currentPlaylistMusics: [MolioMusic] = []
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        publishCurrentPlaylistUseCase: any PublishCurrentPlaylistUseCase,
        musicKitService: any MusicKitService
    ) {
        // 병렬 isrc -> MolioMusic 유즈케이스 구독
        // 현재 플레이리스트 구독
        publishCurrentPlaylistUseCase
            .execute()
            .sink { [weak self] _ in
                
                self?.currentPlaylistMusics = MolioMusic.all
                
//                Task {
//                    self?.currentPlaylistMusics = await musicKitService.getMusic(with: playlist.musicISRCs)
//                }
            }
            .store(in: &subscriptions)
    }

}
