import Combine
import SwiftUI

final class PlaylistDetailViewModel: ObservableObject {
    
    // MARK: - 기본
    
    @Published var currentPlaylist: MolioPlaylist?
    @Published var currentPlaylistMusics: [MolioMusic] = []
    
    @Published private(set) var isAppleMusicSubscriber: Bool = false

    // MARK: - 오디오 플레이어
    
    @Published var currentSelectedMusic: MolioMusic?
    @Published var isPlaying: Bool = false
    
    // MARK: - 내보내기
    
    @Published var exportStatus: ExportStatus = .preparing
    @Published var createdPlaylistURL: String?
    

    
    // MARK: - UseCase
    
    private let managePlaylistUseCase: ManageMyPlaylistUseCase
    private let appleMusicUseCase: AppleMusicUseCase
    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    

    private var currentPlayingMusicIndex: Int? {
        get {
            currentPlaylistMusics.firstIndex { $0.isrc == currentSelectedMusic?.isrc }
        } set {
            // 값이 없거나 새로운 값이 노래 개수를 벗으난 경우에는
            guard let newValue = newValue else {
                currentSelectedMusic = nil
                return
            }
            
            // 새로운 값이 노래 개수를 벗어난 경우에 nil로 설정한다
            guard (0 ..< currentPlaylistMusics.count).contains(newValue) else {
                currentSelectedMusic = nil
                return
            }
            
            self.currentSelectedMusic = currentPlaylistMusics[newValue]
        }
    }
    
    // MARK: - 컴바인
    
    private var subscriptions: Set<AnyCancellable> = []
    private var audioPlayer: AudioPlayer
    
    init(
        managePlaylistUseCase: ManageMyPlaylistUseCase = DefaultManageMyPlaylistUseCase(),
        appleMusicUseCase: any AppleMusicUseCase = DIContainer.shared.resolve(),
        fetchPlaylistUseCase: any FetchPlaylistUseCase = DIContainer.shared.resolve(),
        audioPlayer: AudioPlayer = DIContainer.shared.resolve()
    ) {
        self.managePlaylistUseCase = managePlaylistUseCase
        self.appleMusicUseCase = appleMusicUseCase
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.audioPlayer = audioPlayer
        
        setupAudioPlayer()
        bind()
    }
    
    // MARK: - Audio Player
    

    private func bind() {
        
        // MARK: - 현재 위치한 플레이리스트 받아오기
        
        managePlaylistUseCase.currentPlaylistPublisher()
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
        
        // MARK: - 현재 플레이 중인 노래 AudioPlayer에 바인딩 하기
    
        self.$currentSelectedMusic
            .sink { [weak self] currentPlayingMusic in
                guard let currentPlayingMusic else {
                    // 현재 플레잉하는 노래가 nil이 되면 isPlayling이가 false가 된다
                    self?.isPlaying = false
                    return
                }
                
                if self?.isPlaying == true {
                    self?.audioPlayer.stop()
                } else {
                    // 없을때 누르면 시작한다.
                    self?.isPlaying = true
                    self?.audioPlayer.loadSong(with: currentPlayingMusic.previewAsset)
                    self?.audioPlayer.play()
                }
                
                self?.audioPlayer.loadSong(with: currentPlayingMusic.previewAsset)
                self?.audioPlayer.play()
            }
            .store(in: &subscriptions)
        
        self.$isPlaying
            .sink { [weak self] isPlaying in
                if isPlaying {
                    self?.audioPlayer.play()
                } else {
                    self?.audioPlayer.pause()
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Audio Player Control
    
    private func setupAudioPlayer() {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [self] _ in
            self.handlePlaybackCompletion()
        }
    }
    
    private func handlePlaybackCompletion() {
        self.nextButtonTapped()
    }
    
    func playButtonTapped() {
        guard let currentPlayingMusic = currentSelectedMusic else {
            // 현재 선택된 노래가 없는 경우
            guard let firstMusic = currentPlaylistMusics.first else { return }
            
            self.currentSelectedMusic = firstMusic
            
            return
        }
        
        isPlaying.toggle()
    }
    
    func nextButtonTapped() {
        // 비어있는 경우에는 아무 일도 일어나지 않는다.
        guard !self.currentPlaylistMusics.isEmpty else { return }
        
        // 선택된 노래가 없는 경우에 아무 일도 일어나지 않는다.
        guard let currentPlayingMusicIndex = self.currentPlayingMusicIndex else { return }
        
        // 선택된 노래가 있는 경우에는 다음 노래로 이동한다.
        self.currentPlayingMusicIndex = (currentPlayingMusicIndex + 1) % currentPlaylistMusics.count
    }
    
    func backwardButtonTapped() {
        // 비어있는 경우에는 아무 일도 일어나지 않는다.
        guard !self.currentPlaylistMusics.isEmpty else { return }
        
        // 선택된 노래가 없는 경우에 아무 일도 일어나지 않는다.
        guard let currentPlayingMusicIndex = self.currentPlayingMusicIndex else { return }
        
        // 선택된 노래가 있는 경우에는 이전 노래로 이동한다.
        self.currentPlayingMusicIndex = (currentPlayingMusicIndex - 1 + currentPlaylistMusics.count) % currentPlaylistMusics.count
    }
    
    // MARK: - Audio Player 끝
    
    
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
