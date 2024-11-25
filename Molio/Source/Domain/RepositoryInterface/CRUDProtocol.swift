protocol CRUDProtocol {
    associatedtype Entity
    
    // Create
    func create(_ entity: Entity) async throws
    
    // Read
    func read(by id: String) async throws -> Entity?
    func readAll() async throws -> [Entity]
    
    // Update
    func update(_ entity: Entity) async throws
    
    // Delete
    func delete(by id: String) async throws
}
