import SwiftUI

struct MusicListView: View {
    private let musics: [MolioMusic]
    @Binding private var selectedIndex: Int?

    @State private var isAlertPresenting: Bool = false
    @State private var removeTargetMusic: MolioMusic?

    init(
        musics: [MolioMusic],
        selectedIndex: Binding<Int?>
    ) {
        self.musics = musics
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        List {
            ForEach(musics.indices, id: \.self) { index in
                let music = musics[index]

                // TODO: - 정확한 색상 반영
                MusicCellView(music: music)
                    .listRowBackground(selectedIndex == index ? Color.tag.opacity(0.3) : Color.clear)
                    .listRowSeparatorTint(.gray)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 0))
                    .onTapGesture {
                        selectedIndex = index
                    }
                    .swipeActions {
                        Button {
                            removeTargetMusic = music
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
        .alert("정말 삭제하시겠습니까?", isPresented: $isAlertPresenting, presenting: removeTargetMusic) { music in
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
        print("Delete \(music.title)")
    }
}

#Preview {
    ZStack {
        Color.black
        MusicListView(
            musics: MolioMusic.all,
            selectedIndex: .constant(0)
        )
        .foregroundStyle(.white)
        .background(Color.background)
    }
}
