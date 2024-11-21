import Combine
import SwiftUI

final class MusicFilterViewModel: ObservableObject {
    private let fetchAvailableGenresUseCase: FetchAvailableGenresUseCase
    private let publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase
    private let updatePlaylistUseCase: UpdatePlaylistUseCase
    
    @Published private(set) var allGenres: [MusicGenre]
    @Published private(set) var currentPlaylist: MolioPlaylist?
    @Published private(set) var selectedGenres: Set<MusicGenre>
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        fetchAvailableGenresUseCase: FetchAvailableGenresUseCase = DIContainer.shared.resolve(),
        publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase = MockPublishCurrentPlaylistUseCase(), // TODO: - 의존성 주입
        updatePlaylistUseCase: UpdatePlaylistUseCase = DIContainer.shared.resolve(),
        allGenres: [MusicGenre] = MusicGenre.allCases,
        selectedGenres: Set<MusicGenre> = []
    ) {
        self.fetchAvailableGenresUseCase = fetchAvailableGenresUseCase
        self.publishCurrentPlaylistUseCase = publishCurrentPlaylistUseCase
        self.updatePlaylistUseCase = updatePlaylistUseCase
        self.allGenres = allGenres
        self.selectedGenres = selectedGenres
        
//        getAllGenres() // TODO: - 호출 횟수 조절
        bindCurrentPlaylist()
    }
    
    /// 장르 선택 처리
    func toggleSelection(of genre: MusicGenre) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
    }
    
    /// 모든 장르 종류 불러오기
    private func getAllGenres() {
        Task { @MainActor in
            allGenres = try await fetchAvailableGenresUseCase.execute()
        }
    }
    
    /// 현재 필터 정보 구독
    /// - 현재 플레이리스트
    /// - 현재 플레이리스트에서 선택된 장르들
    private func bindCurrentPlaylist() {
        publishCurrentPlaylistUseCase.execute()
            .sink { [weak self] playlist in
                self?.currentPlaylist = playlist
                self?.selectedGenres = Set<MusicGenre>(playlist?.filter.genres ?? [])
            }
            .store(in: &subscriptions)
    }
    
    /// 장르 설정 정보 저장
    private func saveGenreSelection() throws {
        guard let currentPlaylist = currentPlaylist else { return }
        let newFilter = MusicFilter(genres: Array(selectedGenres))
        let updatedPlaylist = currentPlaylist.updateFilter(to: newFilter)
        Task {
            try await updatePlaylistUseCase.execute(id: currentPlaylist.id, to: updatedPlaylist)
        }
    }
}

// MARK: - Delegate

extension MusicFilterViewModel: MusicFilterViewControllerDelegate {
    func didSaveButtonTapped() {
        do {
            try saveGenreSelection()
        } catch {
            // TODO: - 에러 처리
        }
    }
}
