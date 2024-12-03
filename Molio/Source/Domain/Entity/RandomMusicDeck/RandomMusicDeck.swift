import Combine

protocol RandomMusicDeck {
    var currentMusicTrackModelPublisher: AnyPublisher<MolioMusic?, Never> { get }
    
    var nextMusicTrackModelPublisher: AnyPublisher<MolioMusic?, Never> { get }
    
    var isPreparingMusckDeckPublisher: AnyPublisher<Bool, Never> { get }
    
    func likeCurrentMusic()
    
    func dislikeCurrentMusic()
    
    func reset(with filter: [MusicGenre])
}
