import Combine

final class FriendPlaylistDetailViewModel: ObservableObject {
    @Published private(set) var friendPlaylist: MolioPlaylist?

    @Published private(set) var friendPlaylistMusics: [MolioMusic] = []
    

    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    
    init(
        friendPlaylist: MolioPlaylist,
        fetchPlaylistUseCase: FetchPlaylistUseCase = DefaultFetchPlaylistUseCase()
    ) {
        self.friendPlaylist = friendPlaylist
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        print("받은 것: ", friendPlaylist.musicISRCs.map { $0 })
        self.fetchMusics(for: friendPlaylist)
    }
    
    private func fetchMusics(for playlist: MolioPlaylist) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                // TODO: 친구 아이디가 아닌 경우에도 필요하게 되었다. 임시로 ""로 처리한다. 없어도 된다
                self.friendPlaylistMusics = try await self.fetchPlaylistUseCase.fetchAllFriendMusics(friendUserID: "", playlistID: playlist.id)
                print(self.friendPlaylistMusics)
            } catch {
                print(error)
            }
        }
    }
}
