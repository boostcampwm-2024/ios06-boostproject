import Foundation

extension MolioPlaylist: FirestoreEntity {
    var idString: String {
        id.uuidString
    }
    
    var toDictionary: [String: Any]? {
        [
            "createdAt": createdAt,
            "filters": filter,
            "like": like,
            "musicISRCs": musicISRCs,
            "playlistID": id.uuidString,
            "playlistName": name
        ]
    }
    
    static var collectionName: String {
        "playlists"
    }
    
    static var firebaseIDFieldName: String {
        "playlistID"
    }
}
