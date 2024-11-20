import SwiftUI
import Combine

struct PlaylistDetailView: View {
    @State private var isPlaylistChangeSheetPresented: Bool = false
    @ObservedObject private var viewModel: PlaylistDetailViewModel

    init(
        viewModel: PlaylistDetailViewModel
    ) {
        self.viewModel = viewModel
    }

    var body: some View {
        PlaylistDetailViewList(musics: [.apt, .apt, .apt])
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

                    PlaylistDetailViewAudioPlayerControl()
                        .layoutPriority(1)

                    Spacer(minLength: 20)

                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 66, height: 66)
                            .background(Color.gray, in: .circle)
                    }

                    Spacer(minLength: 20)
                }
                .font(.title)
                .tint(Color.main)
                .frame(maxWidth: .infinity, maxHeight: 66)
                .padding(.bottom)
            }
            .sheet(isPresented: $isPlaylistChangeSheetPresented) {
            }
    }
}
