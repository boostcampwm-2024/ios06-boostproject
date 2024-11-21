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

extension MolioPlaylist {
    static let mock = MolioPlaylist(
        id: UUID(uuidString: "12345678-1234-1234-1234-1234567890ab")!,
        name: "목플레이리스트",
        createdAt: Date(),
        musicISRCs: [],
        filter: MusicFilter(genres: [.pop, .acoustic])
    )
}
