import Foundation

struct FollowRelationDTO: Codable {
    let id: String            // 팔로우 관계 고유 ID
    let date: Date            // 팔로잉한 시점
    let following: String     // 팔로잉한 사용자 ID
    let follower: String      // 팔로워 사용자 ID
    let state: Bool           // true: 수락 상태, false: 대기 상태
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case following
        case follower
        case state
    }
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = jsonObject as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
