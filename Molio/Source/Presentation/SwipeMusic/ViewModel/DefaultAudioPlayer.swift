import AVFoundation

final class DefaultAudioPlayer: AudioPlayer {
    var player: AVQueuePlayer?
    var looper: AVPlayerLooper?
    var updatePlaybackTime: ((Double) -> Void)?
    private var timeObserverToken: Any?
    
    func loadSong(with url: URL) {
        stop()
        let item =  AVPlayerItem(url: url)
        player = AVQueuePlayer(playerItem: item)
        
        guard let player = player else { return }
        
        looper = AVPlayerLooper(player: player, templateItem: item)
        
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
        
//        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1),
//                                                           queue: .main) { [weak self] time in
//            self?.updatePlaybackTime?(time.seconds)
//        }
    }
    
    func play() {
        guard let player = player else { return }
        player.play()
    }
    
    func pause() {
        guard let player = player else { return }
        player.pause()
    }
    
    func stop() {
        guard let player = player else { return }
        player.pause()
        player.seek(to: .zero)
        looper = nil
    }
    
}
