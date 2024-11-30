import Foundation

struct MolioUser: Identifiable {
    let id: String          // 유저의 고유 ID
    var name: String      // 유저 닉네임
    var profileImageURL: URL? // 유저의 사진 URL
    var description: String?  // 유저의 한 줄 설명
}

extension MolioUser {
    static let mock = MolioUser(
        id: "",
        name: "홍길도",
        profileImageURL: URL(string: "https://picsum.photos/200/300"),
        description: "더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽게긴설명더럽" // 50자
    )
}
