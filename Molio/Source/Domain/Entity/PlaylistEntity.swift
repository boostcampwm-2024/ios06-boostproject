import Foundation

struct MolioPlaylist {
    let id: UUID
    let name: String
    let createdAt: Date
    let musicISRCs: [String]
    let filter: MusicFilter
}
