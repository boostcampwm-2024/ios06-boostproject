import SwiftUI
import Combine

struct PlaylistDetailView: View {
    @ObservedObject private var playlistDetailViewModel: PlaylistDetailViewModel
    @StateObject private var audioPlayerViewModel = AudioPlayerControlViewModel()
    
    var didPlaylistButtonTapped: (() -> Void)?
    var didExportButtonTapped: (() -> Void)?

    init(playlistDetailViewModel: PlaylistDetailViewModel) {
        self.playlistDetailViewModel = playlistDetailViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                didPlaylistButtonTapped?()
            } label: {
                HStack(spacing: 10) {
                    Text
                        .molioBold(
                            playlistDetailViewModel.currentPlaylist?.name ?? "제목 없음",
                            size: 34
                        )
                    Image
                        .molioMedium(
                            systemName: "chevron.down",
                            size: 16,
                            color: .white
                        )
                }
                .foregroundStyle(.white)
            }
            .padding(.top, 16)
            .padding(.leading, 22)
            
            // TODO: - 하이라이트 리믹스 & 전체 재생 버튼

            MusicListView()
                .environmentObject(audioPlayerViewModel)
                .environmentObject(playlistDetailViewModel)
        }
        .background(Color.background)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 11) {
                AudioPlayerControlView()
                    .environmentObject(audioPlayerViewModel)
                    .layoutPriority(1)
                
                Button {
                    didExportButtonTapped?()
                } label: {
                    Image
                        .molioSemiBold(
                            systemName: "square.and.arrow.up",
                            size: 20,
                            color: .main
                        )
                }
                .frame(width: 66, height: 66)
                .background(Color.gray)
                .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: 66)
            .padding(.horizontal, 22)
            .padding(.bottom, 23)
        }
        .onChange(of: playlistDetailViewModel.currentPlaylistMusics) { musics in
            audioPlayerViewModel.setMusics(musics)
        }
    }
}

#Preview {
    PlaylistDetailView(
        playlistDetailViewModel: PlaylistDetailViewModel()
    )
}
