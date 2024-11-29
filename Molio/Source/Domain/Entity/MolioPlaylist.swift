import Foundation

struct MolioPlaylist: Identifiable, Hashable {
    let id: UUID
    let authorID: String?
    let name: String
    let createdAt: Date
    let musicISRCs: [String]
    let filter: MusicFilter
    let like: [String]? // TODO

    init(
        id: UUID,
        authorID: String? = nil,
        name: String,
        createdAt: Date,
        musicISRCs: [String],
        filter: MusicFilter,
        like: [String]? = []
    ) {
        self.id = id
        self.authorID = authorID
        self.name = name
        self.createdAt = createdAt
        self.musicISRCs = musicISRCs
        self.filter = filter
        self.like = like
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
    
    func copy(
        id: UUID? = nil,
        authorID: String? = nil,
        name: String? = nil,
        createdAt: Date? = nil,
        musicISRCs: [String]? = nil,
        filter: MusicFilter? = nil,
        like: [String]? = nil
    ) -> MolioPlaylist {
        return MolioPlaylist(
            id: id ?? self.id,
            authorID: authorID ?? self.authorID,
            name: name ?? self.name,
            createdAt: createdAt ?? self.createdAt,
            musicISRCs: musicISRCs ?? self.musicISRCs,
            filter: filter ?? self.filter,
            like: like ?? self.like
        )
    }
}
