import Foundation

extension MolioPlaylist {
    static let samples: [MolioPlaylist] = (1...10).map { index in
        MolioPlaylist(
            id: UUID(),
            name: "Playlist \(index)",
            createdAt: Date().addingTimeInterval(-Double(index * 86400)), // 하루씩 과거 날짜
            musicISRCs: [
                "USUM72021083", // "Peaches" by Justin Bieber
                "USSM12100668", // "Leave The Door Open" by Bruno Mars
                "USRC12003145", // "Save Your Tears" by The Weeknd
                "GBAHS2100386", // "Bad Habits" by Ed Sheeran
                "USUG12101234"  // "Stay" by The Kid LAROI & Justin Bieber
            ],
            filters: ["Filter \(index)", "Genre \((index % 3) + 1)"] // 필터 임의 생성
        )
    }
}
