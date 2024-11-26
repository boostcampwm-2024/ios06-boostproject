import SwiftUI
import Combine

struct PlaylistDetailView: View {
    @State private var isPlaylistChangeSheetPresented: Bool = false
    @State private var selectedIndex: Int?
    @ObservedObject private var viewModel: PlaylistDetailViewModel

    init(viewModel: PlaylistDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                isPlaylistChangeSheetPresented.toggle()
            } label: {
                HStack(spacing: 10) {
                    Text.molioBold(viewModel.currentPlaylist?.name ?? "제목 없음", size: 34)
                    Image.molioMedium(systemName: "chevron.down", size: 16, color: .white)
                }
                .foregroundStyle(.white)
            }
            .padding(.leading, 22)
            
            // TODO: - 하이라이트 리믹스 & 전체 재생 버튼

            MusicListView(musics: .constant(MolioMusic.all + MolioMusic.all + MolioMusic.all), selectedIndex: $selectedIndex)
        }
        .background(Color.background)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 11) {

                AudioPlayerControlView(musics: $viewModel.currentPlaylistMusics, selectedIndex: $selectedIndex)
                    .layoutPriority(1)

                Button {
                    
                } label: {
                    Image.molioSemiBold(systemName: "square.and.arrow.up", size: 20, color: .main)
                }
                .frame(width: 66, height: 66)
                .background(Color.gray)
                .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: 66)
            .padding(.horizontal, 22)
        }
        .sheet(isPresented: $isPlaylistChangeSheetPresented) {
            Text("Playlist Change Sheet")
        }
    }
}

#Preview {
    PlaylistDetailView(
        viewModel: PlaylistDetailViewModel(
            publishCurrentPlaylistUseCase: MockPublishCurrentPlaylistUseCase(playlistToPublish: MolioPlaylist.mock)
        )
    )
}
