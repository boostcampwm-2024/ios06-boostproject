import AVFoundation

final class SwipeMusicPlayer: AudioPlayer {
    var isPlaying: Bool = false
    var player: AVQueuePlayer?
    var looper: AVPlayerLooper?
    
    func loadSong(with url: URL) {
        stop()
        let item =  AVPlayerItem(url: url)
        player = AVQueuePlayer(playerItem: item)
        
        guard let player = player else { return }
        
        looper = AVPlayerLooper(player: player, templateItem: item)
    }
    
    func play() {
        guard let player = player else { return }
        player.play()
        isPlaying = true
    }
    
    func pause() {
        guard let player = player else { return }
        player.pause()
        isPlaying = false
    }
    
    func stop() {
        guard let player = player else { return }
        player.pause()
        player.seek(to: .zero)
        looper = nil
        isPlaying = false
    }
    
}
