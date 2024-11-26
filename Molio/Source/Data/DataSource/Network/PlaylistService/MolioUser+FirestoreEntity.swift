extension MolioUser: FirestoreEntity {
    var idString: String { userID }
    var toDictionary: [String : Any]? {
        [
            "userName": userName,
            "userID": userID,
            "follower": follower,
            "following": following,
            "playlists": playlists,
            "profileImageURL": profileImageURL
        ]
    }
    
    static var firebaseIDFieldName: String {
        "userID"
    }
    
    static var collectionName: String { "users" }
}
