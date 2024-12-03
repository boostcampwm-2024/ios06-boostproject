import Combine

protocol RandomMusicDeck {
    var currentMusic: MolioMusic? { get }
    
    var currentMusicTrackModelPublisher: AnyPublisher<MolioMusic?, Never> { get }
    
    var nextMusicTrackModelPublisher: AnyPublisher<MolioMusic?, Never> { get }
    
    func likeCurrentMusic()
    
    func dislikeCurrentMusic()
    
    func reset(with filter: [MusicGenre])
}
