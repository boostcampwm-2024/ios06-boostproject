import SwiftUI

final class MusicFilterViewModel: ObservableObject {
    private let fetchAvailableGenresUseCase: FetchAvailableGenresUseCase
    
    @Published private(set) var allGenres: [MusicGenre] // TODO: - 전체 장르 시드 불러오기
    @Published private(set) var selectedGenres: Set<MusicGenre>
    
    init(
        fetchAvailableGenresUseCase: FetchAvailableGenresUseCase = DIContainer.shared.resolve(),
        allGenres: [MusicGenre] = MusicGenre.allCases,
        selectedGenres: Set<MusicGenre> = []
    ) {
        self.fetchAvailableGenresUseCase = fetchAvailableGenresUseCase
        self.allGenres = allGenres
        self.selectedGenres = selectedGenres
        
//        getAllGenres() // TODO: - 호출 횟수 조절
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
    
    func saveGenreSelection() {
        
    }
}
