import SwiftUI

struct MusicFilterView: View {
    @ObservedObject private var musicFilterViewModel: MusicFilterViewModel
    
    init(viewModel: MusicFilterViewModel) {
        self.musicFilterViewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text.molioSemiBold("장르", size: 17)
                .foregroundStyle(.white)
            ScrollView {
                TagLayout {
                    ForEach(musicFilterViewModel.allGenres, id: \.self) { genre in
                        FilterTag(
                            content: genre,
                            isSelected: musicFilterViewModel.selectedGenres.contains(genre)
                        ) {
                            musicFilterViewModel.toggleSelection(of: genre)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 22)
    }
}

#Preview {
    ZStack {
        Color.background
        MusicFilterView(
            viewModel: MusicFilterViewModel(
                fetchAvailableGenresUseCase: MockFetchAvailableGenresUseCase(),
                selectedGenres: ["Jazz", "K-Pop"]
            )
        )
    }
}
