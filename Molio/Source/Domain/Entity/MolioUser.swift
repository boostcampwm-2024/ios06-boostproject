import Foundation

struct MolioUser: Identifiable {
    let id: String          // 유저의 고유 ID
    var name: String      // 유저 닉네임
    var profileImageURL: URL? // 유저의 사진 URL
    var description: String?  // 유저의 한 줄 설명
}
