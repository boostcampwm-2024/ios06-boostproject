import SwiftUI

struct MusicFilterView: View {
    @ObservedObject private var musicFilterViewModel: MusicFilterViewModel
    
    var saveButtonTapAction: (() -> Void)?
    
    init(viewModel: MusicFilterViewModel) {
        self.musicFilterViewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(maxWidth: .infinity)
                Text.molioSemiBold("내 필터 편집", size: 17)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: true, vertical: false)
                    .multilineTextAlignment(.center)
                Button {
                    saveButtonTapAction?()
                } label: {
                    Text.molioRegular("저장", size: 17)
                        .foregroundStyle(.mainLighter)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .frame(height: 44)
            .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
            
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
            .padding(.horizontal, 22)
        }
    }
}

#Preview {
    ZStack {
        Color.background
        MusicFilterView(
            viewModel: MusicFilterViewModel(
                fetchAvailableGenresUseCase: MockFetchAvailableGenresUseCase(),
                selectedGenres: [
                    "음악", "얼터너티브", "블루스", "크리스천", "클래식", "컨트리", "댄스",
                    "일렉트로닉", "힙합/랩", "홀리데이", "재즈", "K-Pop", "어린이 음악"
                ]
            )
        )
    }
}
