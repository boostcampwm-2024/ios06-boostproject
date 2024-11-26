import Foundation

extension MolioPlaylist: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(UUID.self, forKey: .playlistID)
        let name = try container.decode(String.self, forKey: .playlistName)
        let createdAt = try container.decode(Date.self, forKey: .createdAt)
        let musicISRCs = try container.decode([String].self, forKey: .musicISRCs)
        let like = try container.decode([String].self, forKey: .like)

        let filtersArray = try container.decode([String].self, forKey: .filters)
        
        let genres = filtersArray.compactMap { MusicGenre(rawValue: $0) }
        
        let filter = MusicFilter(genres: genres)

        self.init(
            id: try container.decode(UUID.self, forKey: .playlistID),
            name: try container.decode(String.self, forKey: .playlistName),
            createdAt: try container.decode(Date.self, forKey: .createdAt),
            musicISRCs: try container.decode([String].self, forKey: .musicISRCs),
            filter: filter,
            like: try container.decode([String].self, forKey: .like)
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case playlistID
        case playlistName
        case musicISRCs
        case filters
        case like
        case createdAt
    }
}
