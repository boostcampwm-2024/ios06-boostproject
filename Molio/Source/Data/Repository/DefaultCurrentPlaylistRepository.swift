import Combine
import Foundation

final class DefaultCurrentPlaylistRepository: CurrentPlaylistRepository {
    // MARK: - Properties
    private let defaults: UserDefaults
    private lazy var currentPlaylistSubject: CurrentValueSubject<UUID?, Never> = {
        if let uuid = getUUID(forKey: .currentPlaylist) {
            return CurrentValueSubject(uuid)
        } else if let uuid = getUUID(forKey: .defaultPlaylist) {
            return CurrentValueSubject(uuid)
        } else {
            return CurrentValueSubject(nil)
            // TODO: UseCase에서 default와 current 저장해주기.
        }
    }()
    var currentPlaylistPublisher: AnyPublisher<UUID?, Never> {
        currentPlaylistSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }
    
    // MARK: - Methods
    func setCurrentPlaylist(_ id: UUID) throws {
        try setIdToUserDefaults(id, key: .currentPlaylist)
    }
    
    func setDefaultPlaylist(_ id: UUID) throws {
        try setIdToUserDefaults(id, key: .defaultPlaylist)
    }
    
    // MARK: - Private Methods
    private func setIdToUserDefaults(_ id: UUID, key: UserDefaultKey) throws {
        let idString = id.uuidString
        
        defaults.set(idString, forKey: key.rawValue)
        
        if key == .currentPlaylist {
            currentPlaylistSubject.send(id)
        }
    }
    
    private func getUUID(forKey key: UserDefaultKey) -> UUID? {
        do {
            let idString = try getIdFromUserDefaults(key: key)
            return UUID(uuidString: idString)
        } catch {
            return nil
        }
    }
    
    private func getIdFromUserDefaults (key: UserDefaultKey) throws -> String {
        guard let idString = defaults.string(forKey: key.rawValue) else {
            throw UserDefaultsError.notFound
        }
        return idString
    }
}
