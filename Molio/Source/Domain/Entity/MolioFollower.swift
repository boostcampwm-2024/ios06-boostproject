import Foundation

/// 팔로워 리스트에서 보여주는 엔티티
struct MolioFollower: Identifiable {
    let id: String          // 유저의 고유 ID
    var name: String      // 유저 닉네임
    var profileImageURL: URL? // 유저의 사진 URL
    var description: String?  // 유저의 한 줄 설명
    var state: Bool
}
extension MolioFollower {
    static let mock = MolioFollower(
        id: "",
        name: "홍길도",
        profileImageURL: URL(string: "https://picsum.photos/200/300"),
        description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽", // 50자
        state: true
    )
    static let mockArray = [
        MolioFollower(
            id: "1",
            name: "홍길도",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽", // 50자
            state: true
        ),
        MolioFollower(
            id: "2",
            name: "홍길동",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽", // 50자
            state: true
        ),
        MolioFollower(
            id: "3",
            name: "홍길두",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽", // 50자
            state: true
        ),
        MolioFollower(
            id: "4",
            name: "홍길둥",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽", // 50자
            state: true
        ),
        MolioFollower(
            id: "5",
            name: "길동",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽", // 50자
            state: true
        ),
    ]
}
