import Foundation

struct MolioUser: Identifiable {
    let id: String          // 유저의 고유 ID
    var name: String      // 유저 닉네임
    var profileImageURL: URL? // 유저의 사진 URL
    var description: String?  // 유저의 한 줄 설명
    
    func convertToFollower(state: Bool) -> MolioFollower {
        return MolioFollower(
            id: self.id,
            name: self.name,
            profileImageURL: self.profileImageURL,
            description: self.description,
            state: state
        )
    }
}

extension MolioUser {
    static let mock = MolioUser(
        id: "",
        name: "홍길도",
        profileImageURL: URL(string: "https://picsum.photos/200/300"),
        description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽" // 50자
    )
    static let mockArray = [
        MolioUser(
            id: "1",
            name: "홍길도",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽" // 50자
        ),
        MolioUser(
            id: "2",
            name: "홍길동",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽" // 50자
        ),
        MolioUser(
            id: "3",
            name: "홍길두",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽" // 50자
        ),
        MolioUser(
            id: "4",
            name: "홍길둥",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽" // 50자
        ),
        MolioUser(
            id: "5",
            name: "길동",
            profileImageURL: URL(string: "https://picsum.photos/200/300"),
            description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽" // 50자
        )
    ]
}
