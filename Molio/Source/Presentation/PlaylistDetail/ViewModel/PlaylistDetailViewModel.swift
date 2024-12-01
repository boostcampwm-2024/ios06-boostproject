import Combine
import SwiftUI

final class PlaylistDetailViewModel: ObservableObject {
    
    // MARK: - 기본
    
    @Published var currentPlaylist: MolioPlaylist?
    @Published var currentPlaylistMusics: [MolioMusic] = []
    
    @Published private(set) var isAppleMusicSubscriber: Bool = false
    
    // MARK: - 내보내기
    
    @Published var exportStatus: ExportStatus = .preparing
    @Published var createdPlaylistURL: String?
    
    // MARK: - UseCase
    
    private let managePlaylistUseCase: ManageMyPlaylistUseCase
    private let appleMusicUseCase: AppleMusicUseCase
    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    
    // MARK: - 컴바인
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        managePlaylistUseCase: ManageMyPlaylistUseCase = DefaultManageMyPlaylistUseCase(),
        appleMusicUseCase: AppleMusicUseCase = DIContainer.shared.resolve(),
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve()
    ) {
        self.managePlaylistUseCase = managePlaylistUseCase
        self.appleMusicUseCase = appleMusicUseCase
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        
        bind()
    }
    
    // MARK: - Audio Player
    
    private func bind() {
        
        // MARK: - 현재 위치한 플레이리스트 받아오기
        
        managePlaylistUseCase
            .currentPlaylistPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] playlist in
                guard let playlist = playlist else { return }
                
                self?.currentPlaylist = playlist
                
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
    
    func deleteMusic(music: MolioMusic) {
        guard let currentPlaylistID = currentPlaylist?.id else { return }
        
        Task { [weak self] in
            do {
                try await self?.managePlaylistUseCase.deleteMusic(musicISRC: music.isrc, from: currentPlaylistID)
            } catch {
                debugPrint("노래 삭제 실패: \(error.localizedDescription)")
            }
            
            do {
                self?.currentPlaylistMusics = try await self?.fetchPlaylistUseCase.fetchAllMyMusicIn(playlistID: currentPlaylistID) ?? []
            } catch {
                debugPrint("노래 목록 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
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
}
