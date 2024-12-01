import Foundation

struct MolioUserDTO: Codable {
    let id: String                // 유저의 고유 ID
    let name: String              // 유저 닉네임
    let profileImageURL: String?  // 유저의 사진 URL
    let description: String?      // 유저의 한 줄 설명
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL
        case description
    }
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = jsonObject as? [String: Any] else {
            return nil
        }
        return dictionary
    }
    
    var toEntity: MolioUser {
        let profileImageURL: URL?
        if let urlString = self.profileImageURL {
            profileImageURL = URL(string: urlString)
        } else {
            profileImageURL = nil
        }
        return MolioUser(
            id: self.id,
            name: self.name,
            profileImageURL: profileImageURL,
            description: self.description
        )
    }
}
