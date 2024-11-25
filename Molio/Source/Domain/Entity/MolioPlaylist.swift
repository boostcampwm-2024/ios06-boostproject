import Foundation

struct MolioPlaylist: Identifiable {
    let id: UUID
    let name: String
    let createdAt: Date
    let musicISRCs: [String]
    let filters: [String]
}
