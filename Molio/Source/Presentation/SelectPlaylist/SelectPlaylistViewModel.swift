import Foundation

final class SelectPlaylistViewModel: ObservableObject {
//    private let createPlaylistUseCase: CreatePlaylistUseCase
//    private let changeCurrentPlaylistUseCase: ChangeCurrentPlaylistUseCase
    @Published var playlists: [MolioPlaylist] = [
        MolioPlaylist(id: UUID(), name: "🎧 카공할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),
        MolioPlaylist(id: UUID(), name: "🤸🏼‍♂️ 헬스할 때 듣는 플리", createdAt: Date(), musicISRCs: [], filters: []),

    ]
        

    
    @Published var selectedPlaylist: MolioPlaylist?
    
//    init(
//        createPlaylistUseCase: CreatePlaylistUseCase = DIContainer.shared.resolve(),
//        changeCurrentPlaylistUseCase: ChangeCurrentPlaylistUseCase = DIContainer.shared.resolve()
//    ) {
//        self.createPlaylistUseCase = createPlaylistUseCase
//        self.changeCurrentPlaylistUseCase = changeCurrentPlaylistUseCase
//    }
    
  
}
