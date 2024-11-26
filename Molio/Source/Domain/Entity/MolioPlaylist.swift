import Foundation

struct MolioPlaylist: Identifiable {
    let id: UUID
    let name: String
    let createdAt: Date
    let musicISRCs: [String]
    let filter: MusicFilter
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
