import SwiftUI

struct MusicListView: View {
    @EnvironmentObject private var viewModel: PlaylistDetailViewModel
    
    @State private var isAlertPresenting: Bool = false
    @State private var removeTargetMusic: MolioMusic?

    var body: some View {
        List {
            ForEach(viewModel.currentPlaylistMusics, id: \.isrc) { rowMusic in
                let listRowBackground = rowMusic.isrc == viewModel.currentSelectedMusic?.isrc
                    ? Color.tag.opacity(0.3)
                    : Color.clear
                
                MusicCellView(music: rowMusic)
                    .listRowBackground(listRowBackground)
                    .listRowSeparatorTint(.gray)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 0))
                    .onTapGesture {
                        viewModel.currentSelectedMusic = viewModel.currentSelectedMusic?.isrc == rowMusic.isrc
                            ? nil
                            : rowMusic
                    }
                    .swipeActions {
                        Button {
                            removeTargetMusic = rowMusic
                            isAlertPresenting.toggle()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
            }
        }
        .foregroundStyle(.white)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .alert(
            "정말 삭제하시겠습니까?",
            isPresented: $isAlertPresenting,
            presenting: removeTargetMusic
        ) { music in
            Button("삭제") {
                deleteMusic(music: music)
                removeTargetMusic = nil
            }
            .tint(.red)
            Button("취소", role: .cancel) {
                removeTargetMusic = nil
            }
        }
    }

    private func deleteMusic(music: MolioMusic) {
        viewModel.deleteMusic(music: music)
    }
}
