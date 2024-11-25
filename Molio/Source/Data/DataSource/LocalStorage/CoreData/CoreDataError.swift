import Foundation

enum CoreDataError: LocalizedError {
    case invalidName
    case saveFailed
    case updateFailed
    case notFound
    case contextUnavailable
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidName:
            return "The playlist name provided is invalid."
        case .saveFailed:
            return "Failed to save the playlist."
        case .updateFailed:
            return "Failed to update the playlist."
        case .notFound:
            return "The requested playlist could not be found."
        case .contextUnavailable:
            return "The Core Data context is unavailable."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
