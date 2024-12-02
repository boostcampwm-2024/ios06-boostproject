import Combine
import SwiftUI

final class MusicFilterViewModel: ObservableObject {
    private let fetchAvailableGenresUseCase: FetchAvailableGenresUseCase
    private let managePlaylistUseCase: ManageMyPlaylistUseCase
    
    @Published private(set) var allGenres: [MusicGenre]
    @Published private(set) var currentPlaylist: MolioPlaylist?
    @Published private(set) var selectedGenres: Set<MusicGenre>
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        fetchAvailableGenresUseCase: FetchAvailableGenresUseCase = DIContainer.shared.resolve(),
        managePlaylistUseCase: ManageMyPlaylistUseCase = DIContainer.shared.resolve(),
        allGenres: [MusicGenre] = [],
        selectedGenres: Set<MusicGenre> = []
    ) {
        self.fetchAvailableGenresUseCase = fetchAvailableGenresUseCase
        self.managePlaylistUseCase = managePlaylistUseCase
        self.allGenres = allGenres
        self.selectedGenres = selectedGenres
        
        getAllGenres()
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
        managePlaylistUseCase.currentPlaylistPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] playlist in
                self?.currentPlaylist = playlist
                self?.selectedGenres = Set<MusicGenre>(playlist?.filter.genres ?? [])
            }
            .store(in: &subscriptions)
    }
    
    /// 새 장르로 변경된 필터 정보로 플레이리스트를 업데이트
    private func updateFilterWithNewGenre() async throws {
        guard let currentPlaylist = currentPlaylist else { return }
        let newFilter = MusicFilter(genres: Array(selectedGenres))
        try await managePlaylistUseCase.updatePlaylistFilter(playlistID: currentPlaylist.id, filter: newFilter)
       
    }
}

// MARK: - Delegate

extension MusicFilterViewModel: MusicFilterViewControllerDelegate {
    /// 저장 버튼 탭 시 동작
    func didSaveButtonTapped() async throws -> MusicFilter {
        try await updateFilterWithNewGenre()
        return MusicFilter(genres: Array(selectedGenres))
    }
}
