import Foundation
import Combine

protocol CurrentPlaylistRepository {
    var currentPlaylistPublisher: AnyPublisher<MolioPlaylist?, Never> { get }
    
    var currentPlaylistFilterPublisher: AnyPublisher<[String], Never> { get }
    
    func setCurrentPlaylist(to: MolioPlaylist)
    
    func setCurrentPlaylistFilter(to: [String])
}
