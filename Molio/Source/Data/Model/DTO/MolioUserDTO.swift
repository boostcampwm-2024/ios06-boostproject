struct MolioUserDTO: Codable {
    let id: String                // 유저의 고유 ID
    var name: String              // 유저 닉네임
    var profileImageURL: String?  // 유저의 사진 URL
    var description: String?      // 유저의 한 줄 설명
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL
        case description
    }
}
