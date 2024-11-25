protocol FirebaseDataModel {
    static var collectionName: String { get }
    static var firebaseIDFieldName: String { get }
    
    var toDictionary: [String: Any]? { get }
}
