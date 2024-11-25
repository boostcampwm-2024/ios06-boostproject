import Foundation
import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()
    private let moliomModelName: String = "MolioModel"
    private let persistenceContainer: NSPersistentContainer
    
    private init() {
        persistenceContainer = NSPersistentContainer(name: moliomModelName)
        persistenceContainer.loadPersistentStores { _, error in
            guard let error = error else { return }
            fatalError("Core Data Stack failed : \(error)")
        }
    }
    
    var context: NSManagedObjectContext {
        return persistenceContainer.viewContext
    }
    
    func saveContext() throws {
        let context = persistenceContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                throw CoreDataError.saveFailed
            }
        }
    }
}
