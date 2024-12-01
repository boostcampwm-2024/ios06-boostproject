import Foundation

final class NotificationViewModel: ObservableObject {
    @Published var pendingFollowRequests: [MolioFollower] = [
        MolioFollower(id: UUID().uuidString, name: "김철수", description: "클래식 음악과 재즈를 사랑하는 사람입니다.", followRelation: .following),
        MolioFollower(id: UUID().uuidString, name: "김철수", description: "클래식 음악과 재즈를 사랑하는 사람입니다.", followRelation: .following),
        MolioFollower(id: UUID().uuidString, name: "김철수", description: "클래식 음악과 재즈를 사랑하는 사람입니다.", followRelation: .following),
        MolioFollower(id: UUID().uuidString, name: "김철수", description: "클래식 음악과 재즈를 사랑하는 사람입니다.", followRelation: .following)
    ]
}
