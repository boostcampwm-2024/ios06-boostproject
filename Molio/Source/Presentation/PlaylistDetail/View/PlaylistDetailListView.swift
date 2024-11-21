import SwiftUI

struct PlaylistDetailListView: View {
    @Binding private var musics: [MolioMusic]
    @Binding private var selectedIndex: Int?

    init(musics: Binding<[MolioMusic]>, selectedIndex: Binding<Int?>) {
        self._musics = musics
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        List(musics.indices, id: \.self) { index in
            let music = musics[index]
            
            PlaylistDetailListItemView(music: music)
                .listRowBackground(selectedIndex == index ? .main.opacity(0.2) : Color.clear)
                .listRowSeparatorTint(.gray)
                .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                .onTapGesture {
                    selectedIndex = index
                }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    ZStack {
        Color.black
        PlaylistDetailListView(
            musics: .constant(
                MolioMusic.all
            ),
            selectedIndex: .constant(0)
        )
        .foregroundStyle(.white)
        .background(Color.background)
    }
}
