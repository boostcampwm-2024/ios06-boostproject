import AVKit
import SwiftUI
import Combine

@MainActor
final class AudioPlayerControlViewModel: ObservableObject {
    
    // MARK: - 기본
    
    @Published var musics: [MolioMusic] = []
    @Published var currentPlayingMusic: MolioMusic?
    @Published var isPlaying: Bool = false
        
    // MARK: - UseCase
    
    private var currentPlayingMusicIndex: Int? {
        get {
            musics.firstIndex { $0.isrc == currentPlayingMusic?.isrc }
        } set {
            // 값이 없거나 새로운 값이 노래 개수를 벗으난 경우에는
            guard let newValue = newValue else {
                currentPlayingMusic = nil
                return
            }
            
            // 새로운 값이 노래 개수를 벗어난 경우에 nil로 설정한다
            guard (0 ..< musics.count).contains(newValue) else {
                currentPlayingMusic = nil
                return
            }
            
            self.currentPlayingMusic = musics[newValue]
        }
    }
    
    private var subscriptions: Set<AnyCancellable> = []
    private var audioPlayer: AudioPlayer

    init(
        audioPlayer: AudioPlayer = DIContainer.shared.resolve()
    ) {
        self.audioPlayer = audioPlayer
        
        setupAudioPlayer()
        bind()
    }
    
    // MARK: - Audio Player
    
    func setMusics(_ musics: [MolioMusic]) {
        self.musics = musics
    }
    
    private func bind() {
        
        // MARK: - 현재 플레이 중인 노래 AudioPlayer에 바인딩 하기
    
        self.$currentPlayingMusic
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentPlayingMusic in
                guard let currentPlayingMusic else {
                    // 현재 플레잉하는 노래가 nil이 되면 isPlayling이가 false가 된다
                    self?.isPlaying = false
                    return
                }
                
                self?.isPlaying = true
                self?.audioPlayer.loadSong(with: currentPlayingMusic.previewAsset)
                self?.audioPlayer.play()
            }
            .store(in: &subscriptions)
        
        self.$isPlaying
            .receive(on: DispatchQueue.main)
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
        guard let currentPlayingMusic else {
            // 현재 선택된 노래가 없는 경우
            guard let firstMusic = musics.first else { return }
            
            self.currentPlayingMusic = firstMusic
            
            return
        }
        
        isPlaying.toggle()
    }
    
    func nextButtonTapped() {
        // 비어있는 경우에는 아무 일도 일어나지 않는다.
        guard !self.musics.isEmpty else { return }
        
        // 선택된 노래가 없는 경우에 아무 일도 일어나지 않는다.
        guard let currentPlayingMusicIndex = self.currentPlayingMusicIndex else { return }
        
        // 선택된 노래가 있는 경우에는 다음 노래로 이동한다.
        self.currentPlayingMusicIndex = (currentPlayingMusicIndex + 1) % musics.count
    }
    
    func backwardButtonTapped() {
        // 비어있는 경우에는 아무 일도 일어나지 않는다.
        guard !self.musics.isEmpty else { return }
        
        // 선택된 노래가 없는 경우에 아무 일도 일어나지 않는다.
        guard let currentPlayingMusicIndex = self.currentPlayingMusicIndex else { return }
        
        // 선택된 노래가 있는 경우에는 이전 노래로 이동한다.
        self.currentPlayingMusicIndex = (currentPlayingMusicIndex - 1 + musics.count) % musics.count
    }
}
