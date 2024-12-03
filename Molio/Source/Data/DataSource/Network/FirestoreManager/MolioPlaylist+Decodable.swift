import Foundation

extension MolioPlaylist: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(
            id: try container.decode(UUID.self, forKey: .playlistID),
            name: try container.decode(String.self, forKey: .playlistName),
            createdAt: try container.decode(Date.self, forKey: .createdAt),
            musicISRCs: try container.decode([String].self, forKey: .musicISRCs),
            filter: try container.decode([String].self, forKey: .filters),
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
