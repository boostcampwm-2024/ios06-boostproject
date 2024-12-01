import SwiftUI

struct FriendPlaylistDetailView: View {
    @ObservedObject var viewModel: FriendPlaylistDetailViewModel

    init(viewModel: FriendPlaylistDetailViewModel) {
        self._viewModel = ObservedObject(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text.molioBold(viewModel.friendPlaylist?.name ?? "제목 없음", size: 34)
                .foregroundStyle(.white)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            // TODO: - 장르 태그 보여주기

            List { 
                ForEach(viewModel.friendPlaylistMusics, id: \.isrc) { molioMusic in
                    MusicCellView(music: molioMusic)
                        .foregroundStyle(.white)
                        .backgroundStyle(.clear)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(.gray)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 0))
                        .swipeActions {
                            Button {
                                viewModel.exportFriendsMusicToMyPlaylist(molioMusic: molioMusic)
                            } label: {
                                Image
                                    .molioSemiBold(
                                        systemName: "square.and.arrow.up",
                                        size: 20,
                                        color: .main
                                    )
                            }
                            .tint(.mainLighter)
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        .background(Color.background)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 11) {
                AudioPlayerControlView()
                    .layoutPriority(1)
            }
            .frame(maxWidth: .infinity, maxHeight: 66)
            .padding(.horizontal, 22)
            .padding(.bottom, 23)
        }
    }
}
