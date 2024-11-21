import Combine
import SwiftUI

final class MusicFilterViewModel: ObservableObject {
    private let fetchAvailableGenresUseCase: FetchAvailableGenresUseCase
    private let publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase
    private let updatePlaylistUseCase: UpdatePlaylistUseCase
    
    @Published private(set) var allGenres: [MusicGenre] // TODO: - 전체 장르 시드 불러오기
    @Published private(set) var selectedGenres: Set<MusicGenre>
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        fetchAvailableGenresUseCase: FetchAvailableGenresUseCase = DIContainer.shared.resolve(),
        publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase = MockPublishCurrentPlaylistUseCase(), // TODO: - 의존성 주입
        updatePlaylistUseCase: UpdatePlaylistUseCase = DIContainer.shared.resolve(),
        allGenres: [MusicGenre] = MusicGenre.allCases,
//        selectedGenres: Set<MusicGenre> = []
    ) {
        self.fetchAvailableGenresUseCase = fetchAvailableGenresUseCase
        self.publishCurrentPlaylistUseCase = publishCurrentPlaylistUseCase
        self.updatePlaylistUseCase = updatePlaylistUseCase
        self.allGenres = allGenres
//        self.selectedGenres = selectedGenres
        
//        getAllGenres() // TODO: - 호출 횟수 조절
        bindCurrentFilter()
    }
    
    func toggleSelection(of genre: MusicGenre) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
    }
    
    func getAllGenres() {
        Task { @MainActor in
            allGenres = try await fetchAvailableGenresUseCase.execute()
        }
    }
    
    func bindCurrentFilter() {
        publishCurrentPlaylistUseCase.execute()
            .sink { [weak self] playlist in
                self?.allGenres = playlist?.filter.genres ?? []
            }
            .store(in: &subscriptions)
    }
    
    func saveGenreSelection() {
        
    }
}

protocol UpdatePlaylistUseCase {
    func execute(id: UUID, to updatedPlaylist: MolioPlaylist) async throws
}
