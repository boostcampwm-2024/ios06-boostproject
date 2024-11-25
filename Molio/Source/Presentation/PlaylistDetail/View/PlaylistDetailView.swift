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
        MusicListView(musics: $viewModel.currentPlaylistMusics, selectedIndex: $selectedIndex)
            .foregroundStyle(.white)
            .listStyle(.plain)
            .background(Color.background)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isPlaylistChangeSheetPresented.toggle()
                    } label: {
                        HStack(spacing: 10) {
                            Text(viewModel.currentPlaylist?.name ?? "제목 없음")
                                .font(.pretendardBold(size: 34))

                            Image(systemName: "chevron.down")
                        }
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .padding(.bottom, 5)

                    }
                }
            }
            .toolbarBackground(
                Color.background,
                for: .navigationBar
            )
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer(minLength: 20)

                    AudioPlayerControlView(musics: $viewModel.currentPlaylistMusics, selectedIndex: $selectedIndex)
                        .layoutPriority(1)

                    Spacer(minLength: 10)

                    Button {
                    } label: {
                        Image.molioExtraBold(systemName: "square.and.arrow.up", size: 20, color: .main)
                    }
                    .frame(width: 66, height: 66) 
                    .background(Color.gray)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    Spacer(minLength: 20)
                }
                .font(.title)
                .tint(Color.main)
                .frame(maxWidth: .infinity, maxHeight: 66)
                .padding(.bottom)
            }
            .sheet(isPresented: $isPlaylistChangeSheetPresented) {
                Text("Playlist Change Sheet")
            }
    }
}

#Preview {
    PlaylistDetailView(viewModel: PlaylistDetailViewModel(publishCurrentPlaylistUseCase: DefaultPublishCurrentPlaylistUseCase(playlistRepository: MockPlaylistRepository(), currentPlaylistRepository: DefaultCurrentPlaylistRepository()), musicKitService: DefaultMusicKitService()))
}
