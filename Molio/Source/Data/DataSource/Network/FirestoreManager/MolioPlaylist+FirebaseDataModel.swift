import Foundation

extension MolioPlaylist: FirebaseDataModel {
    static var collectionName: String {
        "playlists"
    }
    
    static var firebaseIDFieldName: String {
        "playlistID"
    }
    
    var toDictionary: [String: Any]? {
        [
            "createdAt": createdAt,
            "filters": filter.genres.map { $0.rawValue },
            "like": like,
            "musicISRCs": musicISRCs,
            "playlistID": id.uuidString,
            "playlistName": name
        ]
    }
}
