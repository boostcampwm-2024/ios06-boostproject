import Foundation

enum CoreDataError: Error {
    case invalidName
    case saveFailed
    case notFound
    case contextUnavailable
    case unknownError

    var localizedDescription: String {
        switch self {
        case .invalidName:
            return "The playlist name provided is invalid."
        case .saveFailed:
            return "Failed to save the playlist."
        case .notFound:
            return "The requested playlist could not be found."
        case .contextUnavailable:
            return "The Core Data context is unavailable."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
