import SwiftUI

struct PlaylistDetailViewList: View {
    var musics: [MolioMusic]

    var body: some View {
        List(musics, id: \.isrc) { music in
            PlaylistDetailListItemView(music: music)
                .listRowBackground(Color.clear)
                .listRowSeparatorTint(.gray)
                .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    ZStack {
        Color.black
        
        PlaylistDetailViewList(musics: [MolioMusic.apt, MolioMusic.apt, MolioMusic.apt])
            .foregroundStyle(.white)
            .background(Color.background)
    }
}
