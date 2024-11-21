import Foundation

struct MolioPlaylist {
    let id: UUID
    let name: String
    let createdAt: Date
    let musicISRCs: [String]
    let filter: MusicFilter
    
    func updateFilter(to newFilter: MusicFilter) -> Self {
        return MolioPlaylist(
            id: self.id,
            name: self.name,
            createdAt: self.createdAt,
            musicISRCs: self.musicISRCs,
            filter: newFilter
        )
    }
}
