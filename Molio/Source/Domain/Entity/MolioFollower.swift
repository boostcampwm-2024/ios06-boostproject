import Foundation

/// 팔로워 리스트에서 보여주는 엔티티
struct MolioFollower: Identifiable {
    let id: String          // 유저의 고유 ID
    var name: String      // 유저 닉네임
    var profileImageURL: URL? // 유저의 사진 URL
    var description: String?  // 유저의 한 줄 설명
    var state: Bool
}
