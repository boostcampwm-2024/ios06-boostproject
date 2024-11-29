import Foundation

struct MolioPlaylist: Identifiable {
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
    
    static let mock2 = MolioPlaylist(
        id: UUID(uuidString: "2950152E-882C-4BAC-A630-2731A8530A88")!, // 또는 특정 UUID를 사용
        authorID: "창우",
        name: "창우의 목 플레이리스트",
        createdAt: Date(),
        musicISRCs: ["NLA321393034", "USSM10702131", "USRC11700814", "GBHMU1600074", "GBDVX1200008", "USUM71302187", "USUM71300299", "GBAHT0200220", "GBUM70604698", "US5260507213", "USRE19900154", "GBAYE0000566", "GBAHS1500226", "GBAHS1100351", "GBUM71406026", "QZ45A1600041", "UK7PP1400002", "GBHMU1200372", "QMFMK1400002", "USCA20300746", "GBAHS1100203", "USCM51300762", "USMTD0144406", "USJI11000232", "USCN39600066", "USWB11304681", "USUM70918596", "GBARL1200671", "USDMG1260801", "USAT21203287", "USAT21405436", "GBUM71106250", "GBA076600020", "USAT29200016", "USUM71504407", "GBU4B1100007", "US8WW2203908"],
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
