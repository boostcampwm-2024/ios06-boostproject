import FirebaseCore

struct MolioPlaylistDTO: Codable {
    let id: String      // 플레이리스트 고유 ID
    let authorID: String        // 플레이리스트 작성자 ID
    var title: String  // 플레이리스트 이름
    let createdAt: Timestamp       // 생성일
    var filters: [String]     // 필터
    var musicISRCs: [String]  // 음악 ISRC 리스트
    var likes: [String]         // 좋아요를 누른 사용자 ID 리스트
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = jsonObject as? [String: Any] else {
            return nil
        }
        return dictionary
    }
    
    func copy(
        id: String? = nil,
        authorID: String? = nil,
        title: String? = nil,
        createdAt: Timestamp? = nil,
        filters: [String]? = nil,
        musicISRCs: [String]? = nil,
        likes: [String]? = nil
    ) -> MolioPlaylistDTO {
        return MolioPlaylistDTO(
            id: id ?? self.id,
            authorID: authorID ?? self.authorID,
            title: title ?? self.title,
            createdAt: createdAt ?? self.createdAt,
            filters: filters ?? self.filters,
            musicISRCs: musicISRCs ?? self.musicISRCs,
            likes: likes ?? self.likes
        )
    }
}
