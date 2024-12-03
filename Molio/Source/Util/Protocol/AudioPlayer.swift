import AVFoundation

protocol AudioPlayer {
    var isPlaying: Bool { get }
    func loadSong(with url: URL)
    func play()
    func pause()
    func stop()
}
