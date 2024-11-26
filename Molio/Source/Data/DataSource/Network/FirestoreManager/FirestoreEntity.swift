protocol FirestoreEntity: Identifiable {
    var toDictionary: [String: Any]? { get }
    var idString: String { get }
    
    static var collectionName: String { get }
    static var firebaseIDFieldName: String { get }
}
