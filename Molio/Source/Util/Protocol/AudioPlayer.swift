import AVFoundation

protocol AudioPlayer {
    var isPlaying: Bool { get }
    var musicItemDidPlayToEndTimeObserver: NSObjectProtocol? { get nonmutating set }
    func loadSong(with url: URL)
    func play()
    func pause()
    func stop()
}
