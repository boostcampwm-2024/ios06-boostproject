import AVKit
import SwiftUI

struct AudioPlayerControlView: View {
    @Binding private var musics: [MolioMusic]
    @Binding private var selectedIndex: Int?
    @State private var isPlaying: Bool = false
    private var player: AudioPlayer
    
    init(musics: Binding<[MolioMusic]>, selectedIndex: Binding<Int?>, player: AudioPlayer = DIContainer.shared.resolve()) {
        self._musics = musics
        self._selectedIndex = selectedIndex
        self.player = player
        setupPlayer()
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                playPrevious()
            }) {
                Image.molioRegular(systemName: "backward.fill", size: 24, color: .main)
            }
            
            Spacer()
            
            Button(action: {
                togglePlayPause()
            }) {
                Image.molioRegular(systemName: isPlaying ? "pause.fill" : "play.fill", size: 24, color: .main)
            }
            
            Spacer()
            
            Button(action: {
                playNext()
            }) {
                Image.molioRegular(systemName: "forward.fill", size: 24, color: .main)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray, in: .capsule)
        .onChange(of: selectedIndex) { index in
            guard let index = index, musics.indices.contains(index) else { return }
            play(musics[index])
        }
    }
    
    private func setupPlayer() {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [self] _ in
            self.handlePlaybackCompletion()
        }
    }
    
    private func handlePlaybackCompletion() {
        guard let index = selectedIndex else { return }
        
        if index == musics.count - 1 {
            selectedIndex = nil
            isPlaying = false
        } else {
            selectedIndex = index + 1
        }
    }
    
    private func play(_ music: MolioMusic) {
        DispatchQueue.main.async {
            player.loadSong(with: music.previewAsset)
            player.play()
            isPlaying = true
        }
    }
    
    private func togglePlayPause() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            /// 아무것도 선택하지 않고, 재생 버튼을 누르면 처음부터 시작한다.
            if selectedIndex == nil {
                selectedIndex = 0
            }
            if let index = selectedIndex, musics.indices.contains(index) {
                play(musics[index])
            }
            isPlaying = true
        }
    }
    
    private func playNext() {
        if let index = selectedIndex {
            /// 마지막 노래에서 다음노래 버튼 누르면 처음으로 돌아간다
            if (index + 1) == musics.count {
                selectedIndex = 0
            } else {
                selectedIndex = index + 1
            }
        }
    }
    
    private func playPrevious() {
        if let index = selectedIndex {
            /// 처음에서 이전노래 버튼 누르면 맨 마지막 노래로 돌아간다.
            if (index - 1) < 0 {
                selectedIndex = musics.count - 1
            } else {
                selectedIndex = index - 1
            }
        }
    }
}
