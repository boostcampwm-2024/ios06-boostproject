import FirebaseCore

struct MolioPlaylistMapper: BidirectionalMapper {
    typealias Entity = MolioPlaylist
    typealias DTO = MolioPlaylistDTO
    
    private init() {}
    
    static func map(from entity: MolioPlaylist) -> MolioPlaylistDTO {
        return MolioPlaylistDTO(
            id: entity.id.uuidString,
            authorID: entity.authorID,
            title: entity.name,
            createdAt: Timestamp(date: entity.createdAt),
            filters: entity.filter.genres.map { $0.rawValue },
            musicISRCs: entity.musicISRCs,
            likes: entity.like ?? []
        )
    }
    
    static func map(from dto: MolioPlaylistDTO) -> MolioPlaylist {
        return MolioPlaylist(
            // TODO: dto.id가 UUID가 아닐리가 없긴 하지만 나중에 수정하기
            id: UUID(uuidString: dto.id) ?? UUID(),
            authorID: dto.authorID,
            name: dto.title,
            createdAt: dto.createdAt.dateValue(),
            musicISRCs: dto.musicISRCs,
            filter: MusicFilter(genres: dto.filters.compactMap { MusicGenre(rawValue: $0) }),
            like: dto.likes
        )
    }
}
