import SwiftUI
import Combine

final class PlaylistDetailViewModel: ObservableObject {
    @Published var currentPlaylist: MolioPlaylist?
    @Published var currentPlaylistMusics: [RandomMusic] = []
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let parallMusicFetchForISRCsUseCase: any ParallelMusicFetchForISRCsUseCase
    
    init(
        playlistRepository: any CurrentPlaylistRepository,
        parallelMusicFetchForISRCsUseCase: any ParallelMusicFetchForISRCsUseCase
    ) {
        self.parallMusicFetchForISRCsUseCase = parallelMusicFetchForISRCsUseCase
        self.setupCurrentPlaylistPublisher(currentPlaylistPublisher: playlistRepository.currentPlaylistPublisher)
        self.setupCurrentPlaylistMusicsPublisher()
    }
    
    func setupCurrentPlaylistPublisher(currentPlaylistPublisher: AnyPublisher<MolioPlaylist?, Never>) {
        currentPlaylistPublisher
            .sink { [weak self] playlist in
                self?.currentPlaylist = playlist
            }
            .store(in: &subscriptions)
    }
    
    func setupCurrentPlaylistMusicsPublisher() {
        currentPlaylist.publisher
            .flatMap { (currentPlaylist: MolioPlaylist) -> Future<[RandomMusic], Never> in
                let isrcs = currentPlaylist.musicISRCs
                
                return Future { promise in
                    Task { [weak self] in
                        do {
                            let musics = try await self?.parallMusicFetchForISRCsUseCase.execute(isrcs: isrcs)
                            promise(.success(musics ?? []))
                        } catch {
                            // TODO: Error Handling
                        }
                    }
                }
            }
            .sink { [weak self] musics in
                self?.currentPlaylistMusics = musics
            }
            .store(in: &subscriptions)
    }
}

//struct PlaylistDetailViewPlaylistName: View {
//    @State private var currentPlaylistName: String = ""
//    
//    private weak var allPlaylistUseCase: (any PublishAllPlaylistUseCase)?
//    
//    var body: some View {
//        Text(viewModel.currentPlaylist?.name ?? "")
//    }
//}

protocol PublishAllPlaylistUseCase: AnyObject {
    var playlistsPublisher: AnyPublisher<[MolioPlaylist], Never> { get }
}

final class MockPublishAllPlaylistUseCase: PublishAllPlaylistUseCase {
    var playlistsPublisher: AnyPublisher<[MolioPlaylist], Never> {
        Just(MolioPlaylist.samples)
            .eraseToAnyPublisher()
    }
}

protocol PublishCurrentPlaylistUseCase {
    var currentPlaylistPublisher: AnyPublisher<MolioPlaylist?, Never> { get }
}

final class MockPublishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase {
    var currentPlaylistPublisher: AnyPublisher<MolioPlaylist?, Never> {
        Just(MolioPlaylist.samples.first)
            .eraseToAnyPublisher()
    }
}

protocol PublishCurrentPlaylistMusicsUseCase {
    var currentPlaylistMusicsPublisher: AnyPublisher<[RandomMusic], Never> { get }
}
