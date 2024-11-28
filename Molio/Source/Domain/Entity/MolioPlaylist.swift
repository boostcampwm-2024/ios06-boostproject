import Foundation

struct MolioPlaylist: Identifiable {
    let id: UUID
    let authorID: String?
    let name: String
    let createdAt: Date
    let musicISRCs: [String]
    let filters: MusicFilter
    let likes: [String]?

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
        self.authorID = nil
        self.name = name
        self.createdAt = createdAt
        self.musicISRCs = musicISRCs
        self.filter = filter
        self.like = like
    }
    
    func toDTO() -> MockMolioPlaylistDTO? {
        return MockMolioPlaylistDTO(
            id: id.uuidString,
            authorID: authorID ?? "",
            title: name,
            createdAt: Timestamp(date: createdAt),
            filters: filters,
            musicISRCs: musicISRCs,
            likes: likes ?? []
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
    
    func copy(
        id: UUID? = nil,
        name: String? = nil,
        createdAt: Date? = nil,
        musicISRCs: [String]? = nil,
        filter: MusicFilter? = nil,
        like: [String]? = nil
    ) -> MolioPlaylist {
        return MolioPlaylist(
            id: id ?? self.id,
            name: name ?? self.name,
            createdAt: createdAt ?? self.createdAt,
            musicISRCs: musicISRCs ?? self.musicISRCs,
            filter: filter ?? self.filter,
            like: like ?? self.like
        )
    }
}
