struct MolioUser: Identifiable, Decodable {
    var id: String {
        userID
    }
    
    let userName: String
    let userID: String
    let follower: [String]
    let following: [String]
    let playlists: [String]
    let profileImageURL: String
}

extension MolioUser {
    func copy(
        userName: String? = nil,
        userID: String? = nil,
        follower: [String]? = nil,
        following: [String]? = nil,
        playlists: [String]? = nil,
        profileImageURL: String? = nil
    ) -> MolioUser {
        return MolioUser(
            userName: userName ?? self.userName,
            userID: userID ?? self.userID,
            follower: follower ?? self.follower,
            following: following ?? self.following,
            playlists: playlists ?? self.playlists,
            profileImageURL: profileImageURL ?? self.profileImageURL
        )
    }

}
