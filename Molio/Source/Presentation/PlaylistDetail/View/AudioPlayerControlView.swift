import SwiftUI
import AVKit

struct AudioPlayerControlView: View {
    @Binding private var musics: [MolioMusic]
    @Binding private var selectedIndex: Int?
    @State private var isPlaying: Bool = false
    private var player = AVPlayer()
    
    init(musics: Binding<[MolioMusic]>, selectedIndex: Binding<Int?>) {
        self._musics = musics
        self._selectedIndex = selectedIndex
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
            handlePlaybackCompletion()
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
        let item = AVPlayerItem(url: music.previewAsset)
        player.replaceCurrentItem(with: item)
        player.play()
        isPlaying = true
    }
    
    private func togglePlayPause() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else if let index = selectedIndex, musics.indices.contains(index) {
            play(musics[index])
            isPlaying = true
        }
    }
    
    private func playNext() {
        guard let index = selectedIndex, index + 1 < musics.count else { return }
        selectedIndex = index + 1
    }
    
    private func playPrevious() {
        guard let index = selectedIndex, index > 0 else { return }
        selectedIndex = index - 1
    }
}
