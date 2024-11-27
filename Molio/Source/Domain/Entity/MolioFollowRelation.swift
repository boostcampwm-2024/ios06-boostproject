import Foundation

struct MolioFollowRelation: Identifiable {
    let id: String            // 팔로우 관계 고유 ID
    let date: Date            // 팔로잉한 시점
    let following: String     // 팔로잉한 사용자 ID
    let follower: String      // 팔로워 사용자 ID
    var state: Bool           // true: 수락 상태, false: 대기 상태
}
